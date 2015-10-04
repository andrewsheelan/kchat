class @Chat extends React.Component
  constructor: (props) ->
    super props
    @state = props

  render: ->
    React.DOM.div
      id: "message-#{@state.chat.id}"
      style: 
        color: 'red'
      React.DOM.div
        className: 'header'
        React.DOM.strong
          className: 'primary-font'
          @state.chat.user.email
        React.DOM.p null, @state.chat.message
        React.DOM.div
          className: 'pull-right  small text-muted'
          React.DOM.p
            React.DOM.span
              className: 'glyphicon glyphicon-time'
            ' ' + moment( @state.chat.created_info ).fromNow()
        
        React.DOM.div
          style:
            borderBottom: '1px dashed #ccc'
            paddingBottom : '20px'
#$("#p-#{data.id}").emoticonize { delay: 800, animate: true }
#chat_body.scrollTop chat_body.prop('scrollHeight') #Scroll chat to the bottom of the feed
