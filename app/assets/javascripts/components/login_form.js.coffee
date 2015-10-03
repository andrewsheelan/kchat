class @LoginForm extends React.Component
  constructor: (props)->
    @state = 
      email: ''
      password: ''

  valid: =>
    @state.email && @state.password

  handleChange: (e) =>
    name = e.target.name
    @setState "#{ name }": e.target.value

  handleSubmit: (e) ->
    e.preventDefault()
    $.post '/users/sign_in', { user: @state }, (data) =>
      @props.handleNewRecord data
      @setState @getInitialState()
    , 'JSON'

  render: ->
    React.DOM.form
      className: 'form-inline'
      onSubmit: @handleSubmit
      React.DOM.div
        className: 'input-group'
        React.DOM.div
          className: 'input-group-addon',
          'email'
        React.DOM.input
          type: 'text'
          className: 'form-control'
          placeholder: 'Type Here...'
          name: 'email'
          value: @state.email
          onChange: @handleChange
        React.DOM.div
          className: 'input-group-addon',
          'password'
        React.DOM.input
          type: 'password'
          className: 'form-control'
          placeholder: 'Type Here..'
          name: 'password'
          value: @state.password
          onChange: @handleChange
        React.DOM.span
          className: 'input-group-btn'
          React.DOM.button
            type: 'submit'
            className: 'btn btn-primary'
            disabled: !@valid()
            'Login'
