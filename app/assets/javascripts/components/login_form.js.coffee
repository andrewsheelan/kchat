class @LoginForm extends React.Component
  constructor: (props)->
    @state = props
    console.log @state
  valid: =>
    $('.login-form-message').removeClass('css-typing').html('')
    @isValidEmail(@state.email) && @isValidPassword(@state.password)

  isValidEmail: (email)->
    valid = /^[a-z0-9]+([-._][a-z0-9]+)*@([a-z0-9]+(-[a-z0-9]+)*\.)+[a-z]{2,4}$/.test(email) && /^(?=.{1,64}@.{4,64}$)(?=.{6,100}$).*/.test(email)
    $('.login-form-message').
      addClass('css-typing').
      html('Invalid email') unless valid
    valid

  isValidPassword: (password)->
    $('.login-form-message').
      addClass('css-typing').
      html('Enter password.') unless password
    password

  handleChange: (e) =>
    name = e.target.name
    @setState "#{ name }": e.target.value

  handleSubmit: (e) =>
    e.preventDefault()
    Messenger().hideAll()
    $.post('/users/sign_in', {
      user:
          email: @state.email
          password: @state.password
          remember_me: 1
      }, (
        (data) =>
          console.log @state
          @state.setupUserData(data)
          return
      ), 'json'
    ).fail((request, err) ->
      Messenger().post
          message: $.parseJSON(request.responseText).error
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
      className: 'form-inline'
      onSubmit: @handleSubmit
      React.DOM.div
        className: 'input-group login-form'
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
      React.DOM.div
        className: 'small text-muted login-form-message'
