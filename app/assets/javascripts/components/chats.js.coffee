class @Chats extends React.Component
  constructor: (props) ->
    super props
    @state = props
    @state.chats = []

    pusher = new Pusher('debbd1d094d68128387e', encrypted: true)
    channel = pusher.subscribe('test_channel')
    channel.bind @state.logged_user.id, (data) =>
      chats = React.addons.update @state.chats, { $push: [data.chat] }
      @setState chats: chats
      chatBody = $('.chat-body')
      chatBody.animate {
        scrollTop: chatBody.prop('scrollHeight')
      }, 1000
      chatBody.find('p').emoticonize()

  handleSubmit: (e) =>
    e.preventDefault()
    $.post(
      '/chats', {
        chat:
          message: @state.newMessage
        },'JSON'
    ).fail (request, err) ->
        Messenger().post
            message: request.responseText
            type: 'error'
            showCloseButton: true
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
