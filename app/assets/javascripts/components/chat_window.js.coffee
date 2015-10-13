class @ChatWindow extends React.Component
  constructor: (props) ->
    super props
    @state = props
    @chatUrl = "/chats/#{@state.logged_user.id}/with/#{@state.chatWindow.id}"
    @chatBodyCss = ".chat-panel-#{@state.chatWindow.id} .chat-body"
    @eventName = "event-#{[ @state.logged_user.id, @state.chatWindow.id ].sort().join()}"
    pusher = new Pusher('debbd1d094d68128387e', encrypted: true, authEndpoint: '/home/presence_auth' )
    channel = pusher.subscribe("presence-#{@state.logged_user.id}")
    channel.bind @eventName, (data) =>
      chats = React.addons.update @state.chats, { $push: [data.chat] }
      @setState chats: chats
      chatBody = $(@chatBodyCss)
      chatBody.animate {
        scrollTop: chatBody.prop('scrollHeight')
      }, 1000
      chatBody.find('p:last').emoticonize { animate: true, delay: 1000 }

  componentDidMount: ->
    $(".chat-panel-#{@state.chatWindow.id}").draggable()
    @toggleThisChat
    $.get @chatUrl, (chats) =>
      @setState chats: chats
      $(@chatBodyCss).scrollTop $(@chatBodyCss).prop('scrollHeight')
      $(@chatBodyCss).find('p').emoticonize()

  hideThisChat: =>
    @toggleThisChat(true)

  toggleThisChat: (hide) =>
    windowOpen = ".chat-panel-#{@state.chatWindow.id}"
    if $(windowOpen).length
      @bringToFront()
      $(windowOpen).toggle(!hide)

  bringToFront: =>
    windowOpen = ".chat-panel-#{@state.chatWindow.id}"
    $('.chat-div').css('z-index', '100')
    $(windowOpen).css('z-index', '101')

  render: ->
    React.DOM.div
      className: "container chat-div chat-panel-#{@state.chatWindow.id}"
      onClick: @bringToFront
      React.DOM.div
        className: 'col-md-4 col-lg-3 col-sm-4'
        React.DOM.div
          className: 'panel panel-primary'
          React.DOM.div
            className: 'panel-heading'
            style:
              cursor: 'move'
            React.DOM.span
              className: 'panel-max-min'
              React.DOM.span
                className: 'glyphicon glyphicon-comment'
              React.DOM.span
                className: 'user-selected'
                @state.chatWindow.email
              React.DOM.a
                href: '#'
                className: 'text-warning pull-right'
                onClick: @hideThisChat
                React.DOM.span
                  className: 'glyphicon glyphicon-remove'
          React.DOM.div
            className: 'panel-body chat-body-panel'
            React.DOM.div
              className: 'chat-body clearfix'
              if @state.chats.length
                for chat in @state.chats
                  React.createElement Chat, chat: chat, key: chat.id, chatWindowCreated: @state.chatWindow.created
          React.DOM.div
            className: 'panel-footer'
            React.createElement ChatForm, chatUrl: @chatUrl, key: 'chat_form'
