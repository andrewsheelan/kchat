class @App extends React.Component
  constructor: (props) ->
    super props
    @state = props

    @subscribeAllEvents() if @state.logged_user

  subscribeAllEvents: =>
    @pusherAllEvents = new Pusher('debbd1d094d68128387e', encrypted: true, authEndpoint: '/home/presence_auth' )
    channel = @pusherAllEvents.subscribe(@state.logged_user.channel)
    channel.bind_all (event, data) =>
      if data.chat && data.chat.typed_by.id != @state.logged_user.id
        @openSelectedChat data.chat.typed_by.id, data.chat.typed_by.email

  openSelectedChat: (id, email) =>
    windowOpen = ".chat-panel-#{id}"
    if $(windowOpen).length
      $(windowOpen).toggle(true)
    else
      date = new Date()
      date.setSeconds( date.getSeconds() - 2 )
      chatWindow =
        id: id
        email: email
        created: date

      @setupChatWindows(chatWindow)

  setupUserData: (data)=>
    @setState logged_user: data
    @subscribeAllEvents()

  setupChatWindows: (chatWindow)=>
    chatWindows = React.addons.update @state.chatWindows, { $push: [chatWindow] }
    @setState chatWindows: chatWindows

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
      @pusherAllEvents.unsubscribe(@state.logged_user.channel)
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
            if !@state.logged_user
              React.DOM.li
                className: ''
                React.DOM.a
                  href: '#'
                  onClick: @openSignin
                  'Signin'
            if !@state.logged_user
              React.DOM.li
                className: ''
                React.DOM.a
                  href: '#'
                  onClick: @openSignup
                  'Signup'
            if @state.logged_user
              React.DOM.li
                className: 'dropdown user-prof-menu'
                React.DOM.a
                  href: '#'
                  'data-toggle': 'dropdown'
                  React.DOM.img
                    src: @state.logged_user.img_src
                    style:
                      width: '50px'
                      borderRadius: '50%'
                      marginBottom: '-20px'
                      marginTop: '-20px'
                      marginLeft: '20px'
                  React.DOM.b
                    className: "caret"
                  React.DOM.ul
                    className: 'dropdown-menu'
                    React.DOM.li
                      className: ''
                      React.DOM.a
                        href: '#'
                        'Profile'
                    React.DOM.li
                      className: ''
                      React.DOM.a
                        href: '#'
                        onClick: @logout
                        'Logout'
      if @state.logged_user
        React.DOM.div
          className: 'pull-right'
          "Welcome #{@state.logged_user.email}..."

      React.createElement Sidebar, openSelectedChat: @openSelectedChat, users: @state.users, logged_user: @state.logged_user if @state.logged_user
      React.createElement Login, setupUserData: @setupUserData
      React.createElement Signup, setupUserData: @setupUserData
      if @state.logged_user
        for chatWindow in @state.chatWindows
          React.createElement ChatWindow, logged_user: @state.logged_user, chatWindow: chatWindow, chats: [], key: chatWindow.id
