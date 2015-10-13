class @Sidebar extends React.Component
  constructor: (props) ->
    super props
    @state = props

  componentDidMount: ->
    $('[data-toggle="tooltip"]').tooltip()

  showThisChat: (e) =>
    e.preventDefault()
    selection = $(e.target)
    @state.openSelectedChat selection.data('id'), selection.data('email')

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
            if user.id != @state.logged_user.id
              React.createElement SidebarIcon, key: user.id, user: user, showThisChat: @showThisChat
