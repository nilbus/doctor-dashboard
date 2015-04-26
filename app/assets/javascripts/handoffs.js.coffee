class AnnotationRenderer
  constructor: ->
    @relativeizeTimes()
    @showAnnotations()
    @initializeEvents()
    @setupScrollReturn()
    @positionAnnotations()

  showAnnotations: ->
    @annotationsTemplate().hide()
    $('.annotations').show()

  initializeEvents: ->
    $(document).on 'click', '.btn-annotate', (event) =>
      id = $(event.target).closest('.annotatable').attr('id')
      @showAnnotateFormFor(id)
    $('.annotations').on 'click', '.btn-reply', (event) =>
      @handleReplyClick(event)
    $('.annotations').on 'focus', '.annotations-for-id :input', (event) =>
      $(event.target).closest('.annotations-for-id').addClass('raised')
    $('.annotations').on 'blur', '.annotations-for-id :input', (event) =>
      $(event.target).closest('.annotations-for-id').removeClass('raised')
    @initializeCancelTriggers()
    @dimOtherAnnotationsOnHover()

  initializeCancelTriggers: ->
    $(document).on 'keydown', (event) =>
      if event.keyCode == (escapeKeyCode = 27)
        replyBoxes = if $(event.target).is '.reply textarea'
          $(event.target).closest('.reply')
        else
          $('.reply')
        replyBoxes.each (_, replyBox) =>
          @resetReplyForm $(replyBox)
    $('.annotations').on 'click', '.close', (event) =>
      replyBox = $(event.target).closest('.reply')
      @resetReplyForm $(replyBox)

  dimOtherAnnotationsOnHover: ->
    outHandler = ->
      $('.annotations-for-id').removeClass 'backgrounded'
    inHandler = (event) ->
      hovered = $(this)
      focused = $('.reply textarea:focus').closest('.annotations-for-id')
      primary = if focused.length then focused else hovered
      others = $('.annotations-for-id').not(primary)
      others.addClass 'backgrounded'
      primary.removeClass 'backgrounded'
    $('.annotations').on 'mouseenter', '.annotations-for-id', inHandler
    $('.annotations').on 'mouseleave', '.annotations-for-id', outHandler
    $('.annotations').on 'click', '.annotations-for-id', (event) ->
      outHandler()
      $.proxy(inHandler, this)(event)

  showAnnotateFormFor: (id) ->
    @createAnnotationsContainer(id) unless @annotationsContainerFor(id).length
    @showReplyContentFor(id)

  annotationsContainerFor: (id) ->
    $('.annotations-for-id').filter ->
      $(this).data('id') == id

  createAnnotationsContainer: (id) ->
    annotationsContainer = @annotationsTemplate().clone()
    annotationsContainer.attr('data-id', id)
    annotationsContainer.find('.resource-id').val(id)
    annotationsContainer.find('.annotation').remove()
    annotationsContainer.find('.author').addClass('template-temporary')
    annotationsContainer.show()
    $('.annotations').append annotationsContainer
    @positionAnnotations()

  handleReplyClick: (event) ->
    event.preventDefault()
    button = $(event.target)
    replyVisible = button.closest('.reply').find('.reply-content').is(':visible')
    if replyVisible
      @ajaxReply(event) if @readyToSubmit(button)
    else
      id = button.closest('.annotations-for-id').data('id')
      @showReplyContentFor(id)

  ajaxReply: (event) ->
    button = $(event.target)
    buttonPriorText = button.text()
    button.prop 'disabled', true
    button.text 'loading…'
    @submitForm button.closest('form'), (response) =>
      button.text buttonPriorText
      button.prop 'disabled', false
      replyBox = button.closest('.reply')
      if response
        @renderAnnotationResponse(replyBox, response)
        @resetReplyForm(replyBox)

  renderAnnotationResponse: (insertBefore, response) ->
    insertBefore.closest('.annotations-for-id').find('.template-temporary').remove()
    insertBefore.before($(response))
    @relativeizeTimes()

  resetReplyForm: (replyBox) ->
    replyBox.find('textarea').val('')
    replyBox.find('.btn-reply').removeClass('btn-success').addClass('btn-default')
    replyBox.find('.close').hide()
    replyBox.find('.reply-content').hide()

  submitForm: (form, onComplete) ->
    $.ajax
      url: form.attr('action')
      type: 'POST'
      data: form.serialize()
      success: onComplete
      error: ->
        alert "There was an error submitting that. Maybe try again?"
        onComplete()

  showReplyContentFor: (id) ->
    annotationsContainer = @annotationsContainerFor(id)
    annotationsContainer.find('.btn-reply').removeClass('btn-default').addClass('btn-success')
    annotationsContainer.find('.close').show()
    replyContent = annotationsContainer.find('.reply-content')
    replyContent.show()
    replyContent.find('textarea').focus()

  readyToSubmit: (button) ->
    # Assume comment, for now
    commentText = button.closest('.reply').find('textarea')
    notBlank = commentText.val().replace(/\s+/g, '').length > 0
    notBlank

  annotationsTemplate: ->
    $('.annotations-for-id[data-id=template]')

  setupScrollReturn: ->
    @jumpDownPageToBookmark()
    @sendJumpPositionWithCreateHandoffForm()

  jumpDownPageToBookmark: ->
    offsetQuery = '?bookmark='
    urlQuery = window.location.search
    if urlQuery.startsWith offsetQuery
      bookmarkOffset = parseInt(urlQuery.slice(offsetQuery.length))
      handoffSummaryHeight = $('.handoff-summary').height()
      handoffSummaryMargin = 22
      yPosition = bookmarkOffset + handoffSummaryHeight + handoffSummaryMargin
      $(window).scrollTop(yPosition)

  sendJumpPositionWithCreateHandoffForm: ->
    $('.new_handoff').submit ->
      previousAction = $(this).attr('action')
      $('#bookmark-input').remove()
      yPosition = $(window).scrollTop()
      $(this).append "<input id='bookmark-input' type='hidden' name='bookmark' value='#{yPosition}'>"

  positionAnnotations: ->
    annotationGroups = $('.annotations-for-id')
    annotationGroups.each ->
      annotationGroup = $(this)
      annotatable = $(document.getElementById(annotationGroup.data('id'))).closest('.annotatable')
      return unless annotatable.length
      yPosition = annotatable.position().top
      annotationGroup.css position: 'absolute', top: yPosition
    groupsSortedVertically = annotationGroups.sort (a, b) ->
      if $(a).css('top') > $(b).css('top') then 1 else -1
    $('.annotations').append(groupsSortedVertically)

  relativeizeTimes: ->
    $('.relative-time').each ->
      element = $(this)
      return if element.data('relativized')
      dateTime = element.text()
      relativeTime = moment(dateTime).fromNow()
      element.data('relativized', true)
      element.text(relativeTime)
      element.attr('title', dateTime)

new AnnotationRenderer()
