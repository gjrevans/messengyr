import React from 'react';
import ReactDOM from 'react-dom';

import ChatMessage from './chat-message';

import { connect } from 'react-redux';

class ChatContainer extends React.Component {
  render() {
    // Create this variable:
    let messages = this.props.messages.map((message) => {
      return (
        <ChatMessage
          key={message.id}
          message={message}
        />
      );
    });

    return (
      <div className="chat">

        <ul>
          {messages}
        </ul>

        <div className="compose-box">
          <input placeholder="Type a message..." />
          <button>Send</button>
        </div>

      </div>
    )
  }
}

ChatContainer.defaultProps = {
  messages: [],
};

// We mape the state of the app to a props that react can use
const mapStateToProps = (state) => {
  // Get only the active room:
  let activeRoom = state.filter((room) => {
    return room.isActive;
  })[0];

  return {
    // If there is an active room, get its messages!
    // Otherwise, just return an empty list
    messages: (activeRoom) ? activeRoom.messages : [],
  }
};

ChatContainer = connect(
  mapStateToProps,
)(ChatContainer);

export default ChatContainer;
