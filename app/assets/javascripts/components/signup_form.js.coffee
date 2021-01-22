class @SignupForm extends React.Component
  constructor: (props)->
    @state = props

  valid: =>
    $('.signup-form-message').removeClass('css-typing').html('')
    @isValidEmail(@state.email) &&
    @isValidPassword(@state.password) &&
    @isValidPassword(@state.passwordConfirmation)

  isValidEmail: (email)->
    valid = /^[a-z0-9]+([-._][a-z0-9]+)*@([a-z0-9]+(-[a-z0-9]+)*\.)+[a-z]{2,4}$/.test(email) && /^(?=.{1,64}@.{4,64}$)(?=.{6,100}$).*/.test(email)
    $('.signup-form-message').
      addClass('css-typing').
      html('Please enter a valid email.') unless valid
    valid

  isValidPassword: (password)->
    $('.signup-form-message').
      addClass('css-typing').
      html('Enter password.') unless password
    password

  handleChange: (e) =>
    name = e.target.name
    @setState "#{ name }": e.target.value

  handleSubmit: (e) =>
    e.preventDefault()
    Messenger().hideAll()
    $.post('/users', {
      user:
          email: @state.email
          password: @state.password
          password_confirmation: @state.passwordConfirmation
      }, (
        (data) =>
          @state.setupUserData(data)
          return
      ), 'json'
    ).fail((request, err) ->
      Messenger().post
          message: strfy($.parseJSON(request.responseText).errors)
          type: 'error'
          showCloseButton: true
    ).success((data, textStatus, xhr) =>
      csrf_param = xhr.getResponseHeader('X-CSRF-Param')
      csrf_token = xhr.getResponseHeader('X-CSRF-Token')
      $("meta[name='csrf-param']").attr('content', csrf_param) if csrf_param
      $("meta[name='csrf-token']").attr('content', csrf_token) if csrf_token
      Messenger().post
        message: 'Successfully Logged in..'
        type: 'success'
      $('.modal').modal('hide')
    )
  render: ->
    React.DOM.form
      className: ''
      onSubmit: @handleSubmit
      React.DOM.div
        className: 'signup-form'
        React.DOM.div
          className: 'form-group'
          React.DOM.label
            className: 'control-label'
            htmlFor: 'email',
            'Email'
          React.DOM.input
            type: 'text'
            className: 'form-control'
            placeholder: 'Type Here...'
            name: 'email'
            value: @state.email
            onChange: @handleChange
        React.DOM.div
          className: 'form-group'
          React.DOM.label
            className: 'control-label'
            htmlFor: 'password',
            'Password'
          React.DOM.input
            type: 'password'
            className: 'form-control'
            placeholder: 'Type Here..'
            name: 'password'
            value: @state.password
            onChange: @handleChange
        React.DOM.div
          className: 'form-group'
          React.DOM.label
            className: 'control-label'
            htmlFor: 'passwordConfirmation',
            'Password Confirmation'
          React.DOM.input
            type: 'password'
            className: 'form-control'
            placeholder: 'Type Here..'
            name: 'passwordConfirmation'
            value: @state.passwordConfirmation
            onChange: @handleChange

        React.DOM.button
          type: 'submit'
          className: 'btn btn-primary'
          disabled: !@valid()
          'Signup'
      React.DOM.div
        className: 'small text-muted signup-form-message'
