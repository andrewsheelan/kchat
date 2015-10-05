class @Chats extends React.Component
  constructor: (props) ->
    super props
    @state = props

    pusher = new Pusher('debbd1d094d68128387e', encrypted: true)
    channel = pusher.subscribe('test_channel')
    channel.bind 'test_user', (data) =>
      chats = React.addons.update @state.chats, { $push: [data.chat] }
      @setState chats: chats
      chatBody = $('.chat-body')
      chatBody.animate {
        scrollTop: chatBody.prop('scrollHeight')
      }, 1000
      chatBody.find('p').emoticonize()

  selectedUser: (e) =>
    selection = $(e.target)
    @setState selectedUserId: selection.data('id')
    $('.user-selected').html selection.data('email')

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
                  ' Chat:'
                React.DOM.span
                  className: 'user-selected'
                  ' [select]'
                React.DOM.div
                  className: 'btn-group pull-right'
                  React.DOM.button
                    className: 'btn btn-default btn-xs dropdown-toggle'
                    type: 'button'
                    'data-toggle': 'dropdown'
                    React.DOM.span
                      className: 'glyphicon glyphicon-chevron-down'
                  React.DOM.ul
                    className: 'dropdown-menu slidedown'
                    if @state.users.length
                      for user in @state.users
                        React.DOM.li
                          className: 'list'
                          React.DOM.a
                            className: 'user-select'
                            href: "#"
                            onClick: @selectedUser
                            'data-id': user.id
                            'data-email': user.email
                            React.DOM.span
                              className: 'glyphicon glyphicon-user'
                            " #{user.email}"

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
