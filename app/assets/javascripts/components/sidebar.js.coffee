class @Sidebar extends React.Component
  constructor: (props) ->
    super props
    @state = props

  componentDidMount: ->
    $('[data-toggle="tooltip"]').tooltip()

  showThisChat: (e) ->
    e.preventDefault()
    selection = $(e.target)
    $('.user-selected').html " #{selection.data('original-title')}"
    $('.chat-div').show()

  render: ->
    React.DOM.div
      className: 'wrapper'
      React.DOM.div
        className: 'sidebar-wrapper'
        React.DOM.ul
          className: 'sidebar-nav'
          React.DOM.li
            className: 'sidebar-brand'
            React.DOM.a
              href: '#'
              'Users'
          for user in @state.users
            React.DOM.li
              className: 'item'
              React.DOM.a
                href: '#'
                onClick: @showThisChat
                React.DOM.img
                  className: 'img-circle'
                  src: "//www.gravatar.com/avatar/#{user.md5}"
                  'data-toggle': 'tooltip'
                  'data-placement': 'right'
                  title: user.email
