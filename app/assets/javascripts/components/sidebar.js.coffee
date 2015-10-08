class @Sidebar extends React.Component
  constructor: (props) ->
    super props
    @state = props

  componentDidMount: ->
    $('[data-toggle="tooltip"]').tooltip()

  showThisChat: (e) =>
    e.preventDefault()
    selection = $(e.target)
    windowOpen = ".chat-panel-#{selection.data('id')}"
    if $(windowOpen).length
      $(windowOpen).toggle(true)
    else
      chatWindow =
        email: selection.data('email')
        id: selection.data('id')
        show: true

      @state.setupChatWindows(chatWindow)

  render: ->
    React.DOM.div
      className: 'wrapper'
      React.DOM.div
        className: 'sidebar-wrapper'
        React.DOM.ul
          className: 'sidebar-nav'
          React.DOM.li
            className: 'sidebar-brand'
            React.DOM.a
              href: '#'
              'Users'
          for user in @state.users
            React.createElement SidebarIcon, key: user.id, user: user, showThisChat: @showThisChat
