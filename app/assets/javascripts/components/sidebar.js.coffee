class @Sidebar extends React.Component
  constructor: (props) ->
    super props
    @state = props

  componentDidMount: ->
    $('[data-toggle="tooltip"]').tooltip()
    setInterval(( =>
      $.get '/people', (users) =>
        @updateUsers(users)
    ), 10000 )

  updateUsers: (users)=>
    @setState users: users
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
              React.DOM.li
                className: 'item'
                React.DOM.a
                  href: '#'
                  onClick: @showThisChat
                  'data-id': user.id
                  'data-email': user.email
                  React.DOM.img
                    className: "img-circle online-#{ user.online}"
                    src: user.img_src
                    'data-toggle': 'tooltip'
                    'data-placement': 'right'
                    'data-id': user.id
                    'data-email': user.email
                    'data-original-title': user.email
                    title: user.email
