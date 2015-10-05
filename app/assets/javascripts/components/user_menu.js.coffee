class @UserMenu extends React.Component
  constructor: (props) ->
    super props
    @state = logged_user: ''
    console.log @state.logged_user

  setupUserData: (data)=>
    @setState logged_user: data
    console.log data

  openSignin: (e)=>
    e.preventDefault()
    $('.modal').modal('show')

  signoff: (e) =>
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
              className: 'nav navbar-nav'
              React.DOM.li
                className: (if @state.logged_user then 'hide' else '')
                React.DOM.a
                  href: '#'
                  onClick: @openSignin
                  'signin'
              React.DOM.li
                className: (if @state.logged_user then 'hide' else '')
                React.DOM.a href: '#', 'signup'
              React.DOM.li
                className: (if @state.logged_user then '' else 'hide')
                React.DOM.a
                  href: '#'
                  onClick: @signoff
                  'signoff'
      React.createElement Login, setupUserData: @setupUserData
      React.createElement Chats if @state.logged_user
