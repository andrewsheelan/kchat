class @UserMenu extends React.Component
  constructor: (props) ->
    super props
    @state = props

  setupUserData: (data)=>
    @setState logged_user: data

  openSignin: (e)=>
    e.preventDefault()
    $('.login-modal').modal('show').on 'shown.bs.modal',
      -> $(this).find('input:text:visible:first').focus()

  openSignup: (e)=>
    e.preventDefault()
    $('.signup-modal').modal('show').on 'shown.bs.modal',
      -> $(this).find('input:text:visible:first').focus()

  logout: (e) =>
    e.preventDefault()
    $.ajax(
      url: '/users/sign_out'
      type: 'DELETE'
    ).success((data, textStatus, xhr) =>
      csrf_param = xhr.getResponseHeader('X-CSRF-Param')
      csrf_token = xhr.getResponseHeader('X-CSRF-Token')
      $("meta[name='csrf-param']").attr('content', csrf_param) if csrf_param
      $("meta[name='csrf-token']").attr('content', csrf_token) if csrf_token
      @setState logged_user: ''
      Messenger().post
        message: 'Successfully Logged out..'
        type: 'success'
    )
  render: ->
    React.DOM.div
      className: 'kchat'
      React.DOM.nav
        className: 'navbar navbar-inverse navbar-fixed-top'
        role: 'navigation'
        React.DOM.div
          className: 'container'
          React.DOM.div
            className: 'navbar-header'
            React.DOM.button
              className: 'navbar-toggle collapsed'
              type: 'button'
              'data-toggle': 'collapse'
              'data-target': '#navbar'
              'aria-expanded': 'false'
              'aria-controls': 'navbar'
              React.DOM.span
                className: 'sr-only'
                'Toggle navigation'
              React.DOM.span
                className: 'icon-bar'
              React.DOM.span
                className: 'icon-bar'
              React.DOM.span
                className: 'icon-bar'
            React.DOM.a
              className: 'navbar-brand'
              href: '#'
              'kChat'
          React.DOM.div
            className: 'collapse navbar-collapse'
            id: 'navbar'
            React.DOM.ul
              className: 'nav navbar-nav pull-right'
              React.DOM.li
                className: (if @state.logged_user then 'hide' else '')
                React.DOM.a
                  href: '#'
                  onClick: @openSignin
                  'Signin'
              React.DOM.li
                className: (if @state.logged_user then 'hide' else '')
                React.DOM.a
                  href: '#'
                  onClick: @openSignup
                  'Signup'
              React.DOM.li
                className: (if @state.logged_user then '' else 'hide')
                React.DOM.a
                  href: '#'
                  onClick: @logout
                  'Logout'
      React.createElement Login, setupUserData: @setupUserData
      React.createElement Signup, setupUserData: @setupUserData
      React.createElement Chats,
              logged_user: @state.logged_user,
              users: @state.users, chats: [] if @state.logged_user
