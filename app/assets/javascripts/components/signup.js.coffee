class @Signup extends React.Component
  constructor: (props) ->
    super props
    @state = props

  render: ->
    React.DOM.div
      className: 'modal fade signup-modal'
      React.DOM.div
        className: 'modal-dialog'
        React.DOM.div
          className: 'modal-content'
          React.DOM.div
             className: 'modal-body'
             React.createElement SignupForm, setupUserData: @state.setupUserData
