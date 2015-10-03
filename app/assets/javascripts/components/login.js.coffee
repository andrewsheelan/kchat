class @Login extends React.Component
  constructor: (props) ->
    super props
    @state = props

  render: ->
    React.DOM.div
      className: 'modal fade'
      React.DOM.div
        className: 'modal-dialog'
        React.DOM.div
          className: 'modal-content'
          React.DOM.div 
             className: 'modal-body'
             React.createElement LoginForm

