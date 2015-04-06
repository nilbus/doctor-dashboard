class AnnotationRenderer
  constructor: ->
    @hideTemplates()
    @initializeEvents()
    @positionAnnotations()

  hideTemplates: ->
    @annotationsTemplate().hide()

  initializeEvents: ->
    $(document).on 'click', '.btn-annotate', (event) =>
      id = $(event.target).closest('.annotatable').attr('id')
      @showAnnotateFormFor(id)
    $('.annotations').on 'click', '.btn-reply', (event) =>
      id = $(event.target).closest('.annotations-for-id ').data('id')
      @showReplyContentFor(id)

  showAnnotateFormFor: (id) ->
    @createAnnotationsContainer(id) unless @annotationsContainerFor(id).length
    @showReplyContentFor(id)

  annotationsContainerFor: (id) ->
    $('.annotations-for-id').filter ->
      $(this).data('id') == id

  createAnnotationsContainer: (id) ->
    annotationsContainer = @annotationsTemplate().clone()
    annotationsContainer.attr('data-id', id)
    annotationsContainer.find('.annotation').remove()
    annotationsContainer.show()
    $('.annotations').append annotationsContainer
    @positionAnnotations()

  showReplyContentFor: (id) ->
    annotationsContainer = @annotationsContainerFor(id)
    annotationsContainer.find('.reply-content').show()
      .find('textarea').focus()

  annotationsTemplate: ->
    $('.annotations-for-id[data-id=template]')

  positionAnnotations: ->
    # $annotationContainer = $('.annotations')
    # $annotatable = $(document.getElementById(annotation.id)).closest('.annotatable')
    # return if $annotatable.size() == 0
    # yPosition = $annotatable.position().top
    # $element = $("
    #   <div class='annotation panel panel-default'>
    #     <div class='panel-heading'>#{annotation.author.name}</div>
    #     <div class='panel-body'>
    #       #{annotation.html}
    #       <a href=''>reply</a>
    #     </div>
    #   </div>
    # ")
    # $annotationContainer.append $element
    # $element.css position: 'absolute', top: yPosition

new AnnotationRenderer()
