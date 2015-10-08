class @ChatWindow extends React.Component
  constructor: (props) ->
    super props
    @state = props
    @chatUrl = "/chats/#{@state.logged_user.id}/with/#{@state.chatWindow.id}"
    @chatBodyCss = ".chat-panel-#{@state.chatWindow.id} .chat-body"
    @eventName = "event-#{[ @state.logged_user.id, @state.chatWindow.id ].sort().join()}"
    pusher = new Pusher('debbd1d094d68128387e', encrypted: true)
    channel = pusher.subscribe("channel-#{@state.logged_user.id}")
    channel.bind @eventName, (data) =>
      data.chat.enabled = true
      chats = React.addons.update @state.chats, { $push: [data.chat] }
      @setState chats: chats
      chatBody = $(@chatBodyCss)
      chatBody.animate {
        scrollTop: chatBody.prop('scrollHeight')
      }, 1000
      chatBody.find('p').emoticonize()

  componentDidMount: ->
    $(".chat-panel-#{@state.chatWindow.id}").draggable()
    @showThisChat(true)
    $.get @chatUrl, (chats) =>
      @setState chats: chats
      $(@chatBodyCss).scrollTop $(@chatBodyCss).prop('scrollHeight')

  showThisChat: (show) =>
    chatWindow = @state.chatWindow
    chatWindow.show = show
    @setState chatWindow: chatWindow

  hideThisChat: (e) =>
    @showThisChat(false)

  render: ->
    React.DOM.div
      className: "container chat-div chat-panel-#{@state.chatWindow.id} #{if @state.chatWindow.show then '' else 'hide' }"
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
                  React.createElement Chat, chat: chat, key: chat.id
          React.DOM.div
            className: 'panel-footer'
            React.createElement ChatForm, chatUrl: @chatUrl, key: 'chat_form'
