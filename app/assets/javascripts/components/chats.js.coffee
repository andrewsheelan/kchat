class @Chats extends React.Component
  constructor: (props) ->
    super props
    @state = props

  handleSubmit: (e) =>
    e.preventDefault()
    $.post '/chats', { chat: { message: @state.newMessage} }, 'JSON'

  valid: =>
    @state.newMessage

  handleChange: (e) =>
    @setState "newMessage": e.target.value

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
                for chat in @state.chats
                  React.createElement Chat, chat: chat, key: chat.id
            React.DOM.div
              className: 'panel-footer'
              React.DOM.div
                className: 'input-group'
                React.DOM.input
                  className: 'form-control input-sm'
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
