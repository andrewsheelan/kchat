class @Chats extends React.Component
  constructor: (props) ->
    super props
    @state = chats: []
    @ws = new WebSocket("ws://" + location.host + "/chats/chat")
    @ws.onmessage = (e) =>
      chatBody = $(".chat-body")
      scrollSpeed = 0
      chats = $.parseJSON e.data
      unless chats.length
        chats = React.addons.update @state.chats, { $push: [chats] }
        scrollSpeed = 1000

      @setState chats: chats
      chatBody.animate {
        scrollTop: chatBody.prop('scrollHeight')
      }, scrollSpeed
      chatBody.find('p').emoticonize()

  handleSubmit: (e) =>
    e.preventDefault()
    @ws.send(@state.newMessage)
    $('.chat-message-bar').val ''

  valid: =>
    @state.newMessage

  handleChange: (e) =>
    @setState newMessage: e.target.value

  render: ->
    React.DOM.div
      className: 'container'
      React.DOM.form
        onSubmit: @handleSubmit
        className: 'form-inline'
        React.DOM.div
          className: 'col-md-4 col-lg-3 col-sm-4'
          React.DOM.div
            className: 'panel panel-primary'
            React.DOM.div
              className: 'panel-heading'
              style:
                cursor: 'pointer'
              React.DOM.span
                className: 'panel-max-min'
                React.DOM.span
                  className: 'glyphicon glyphicon-comment'
                  Chat
                React.DOM.span
                  className: 'user-heading'
                  Chat
            React.DOM.div
              className: 'panel-body'

              React.DOM.div
                className: 'chat-body clearfix'
                style:
                  height: '300px'
                  overflow: 'scroll'
                if @state.chats.length
                  for chat in @state.chats
                    React.createElement Chat, chat: chat, key: chat.id
            React.DOM.div
              className: 'panel-footer'
              React.DOM.div
                className: 'input-group'
                React.DOM.input
                  className: 'form-control input-sm chat-message-bar'
                  type: 'text'
                  name: 'message'
                  onChange: @handleChange
                  placeholder: 'Type your message here...'
                React.DOM.span
                  className: 'input-group-btn'
                  React.DOM.input
                    className: 'btn btn-warning btn-sm'
                    value: 'Send'
                    disabled: !@valid()
                    type: 'submit'
