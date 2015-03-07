annotations = [
  {
    id: 'prescription-1'
    type: 'comment'
    author:
      name: 'The Doctor'
    html: 'I like this, this is good. We need more of this.'
    created_at: '1/2/2015 5:30:11 am'
  }
]

class AnnotationRenderer
  constructor: (@annotations = []) ->

  render: ->
    @renderAnnotation(annotation) for annotation in @annotations

  renderAnnotation: (annotation) ->
    $annotationContainer = $('.annotations')
    $annotatable = $(".annotatable##{annotation.id}")
    yPosition = $annotatable.position().top
    $element = $("
      <div class='annotation panel panel-default'>
        <div class='panel-heading'>#{annotation.author.name}</div>
        <div class='panel-body'>
          #{annotation.html}
          <a href=''>reply</a>
        </div>
      </div>
    ")
    $annotationContainer.append $element
    $element.css position: 'absolute', top: yPosition

$ ->
  new AnnotationRenderer(annotations).render()
