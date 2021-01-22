class @ChatForm extends React.Component
  constructor: (props) ->
    super props
    @state = props

  valid: =>
    @state.newMessage

  handleChange: (e) =>
    @setState newMessage: e.target.value

  handleSubmit: (e) =>
    e.preventDefault()
    $.post(
      @state.chatUrl, {
        chat:
          message: @state.newMessage
        },'JSON'
    ).fail (request, err) ->
        Messenger().post
            message: strfy($.parseJSON(request.responseText).errors)
            type: 'error'
            showCloseButton: true
    @setState newMessage: ''

  render: ->
    React.DOM.form
      onSubmit: @handleSubmit
      className: 'form-inline'
      React.DOM.div
        className: 'input-group'
        React.DOM.input
          className: 'form-control input-sm chat-message-bar'
          type: 'text'
          name: 'message'
          value: @state.newMessage
          onChange: @handleChange
          placeholder: 'Type your message here...'
        React.DOM.span
          className: 'input-group-btn'
          React.DOM.input
            className: 'btn btn-warning btn-sm'
            value: 'Send'
            disabled: !@valid()
            type: 'submit'
