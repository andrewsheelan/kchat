class @Sidebar extends React.Component
  constructor: (props) ->
    super props
    @state = props

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
                React.DOM.img
                  className: 'img-circle'
                  src: "//www.gravatar.com/avatar/#{user.md5}"
                React.DOM.span
                  className: 'item-email'
                  " #{user.email}"
