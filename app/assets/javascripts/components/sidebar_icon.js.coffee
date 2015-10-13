class @SidebarIcon extends React.Component
  constructor: (props) ->
    super props
    @state = props

  render: ->
    React.DOM.li
      className: 'item'
      React.DOM.a
        href: '#'
        onClick: @state.showThisChat
        'data-id': @state.user.id
        'data-email': @state.user.email
        React.DOM.img
          className: 'img-circle'
          src: "//www.gravatar.com/avatar/#{@state.user.md5}?d=mm"
          'data-toggle': 'tooltip'
          'data-placement': 'right'
          'data-id': @state.user.id
          'data-email': @state.user.email
          title: @state.user.email
