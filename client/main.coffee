css = new CSSC
css.add '.red-bg',
  borderRadius: CSSC.px 10
  backgroundColor: CSSC.red
  textAlign: 'center'
  lineHeight: CSSC.px 200
  fontWeight: 'bold'
  color: CSSC.white
  fontSize: CSSC.px 22
  cursor: 'default'
  # Prevent user's selection of the button
  userSelect: 'none'
  mozUserSelect: 'none'
  webkitUserSelect: 'none'
  webkitTouchCallout: 'none'

Engine = famous.core.Engine
SnapTransition = famous.transitions.SnapTransition
Transitionable = famous.transitions.Transitionable
Transitionable.registerMethod 'snap', SnapTransition

transitionable = null
final_pos = null
blurred = false
surface = null
snap =
  method: 'snap'
  period: 400
  dampingRatio: .7

blur_from_to = (i, f, transition) ->
  initial_pos = i
  final_pos = f
  transitionable = new Transitionable initial_pos
  transitionable.set final_pos, transition
  Engine.on 'prerender', prerender

prerender = ->
  current_pos = transitionable.get()
  blur_string = "blur(#{CSSC.px current_pos})"
  surface.setProperties webkitFilter: blur_string
  if current_pos is final_pos
    Engine.removeListener 'prerender', prerender

Template.blurred.rendered = ->
  surface = (FView.byId 'surf').surface
  surface.on 'click', ->
    [start, end] = if blurred then [0, 10] else [10, 0]
    blur_from_to start, end, snap
    blurred = not blurred
