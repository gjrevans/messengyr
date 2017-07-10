import React          from 'react';
import ReactDOM       from 'react-dom';
import MenuMessage    from './menu-message';

import { connect }    from 'react-redux';
import { setRooms, selectRoom, addRoom } from '../actions';

import socket from "../socket";

let getRoomChannel = (roomId) => {
  let channel = socket.channel(`room:${roomId}`);

  channel.join()
  .receive("ok", resp => {
    console.info(`Joined room ${roomId} successfully`, resp);
  })
  .receive("error", resp => {
    console.error(`Unable to join ${roomId}`, resp);
  });

  return channel;
};

class MenuContainer extends React.Component {
  componentDidMount() {
    fetch('/api/rooms', {
      headers: {
        "Authorization": "Bearer " + window.jwtToken,
      },
    })
    .then((response) => {
      return response.json();
    })
    .then((response) => {
      let rooms = response.rooms;

      // Get the room channel for each room...
      rooms.forEach((room) => {
        room.channel = getRoomChannel(room.id);
      });

      // ... then add the rooms to the Redux store:
      this.props.setRooms(rooms);


      // Get the first room in the list:
      let firstRoom = rooms[0];

      // If it exists, send its ID to the "selectRoom" action:
      if (firstRoom) {
        this.props.selectRoom(firstRoom.id);
      }
    })
    .catch((err) => {
      console.error(err);
    });
  }

  createRoom() {
    let username = prompt("Enter a username");

    let data = new FormData();
    data.append("counterpartUsername", username);

    fetch('/api/rooms', {
      method: "POST",
      headers: {
        "Authorization": "Bearer " + window.jwtToken,
      },
      body: data,
    })
    .then((response) => {
      return response.json();
    })
    .then((response) => {
      let room = response.room;

      // Call the action from your component:
      this.props.addRoom(room);
    })
    .catch((err) => {
      console.error(err);
    });
  }

  render() {
    // Get a date from a room we want to sort:
    let getRoomDate = (room) => {
      let date;

      if (room.lastMessage) {
        date = room.lastMessage.sentAt;
      } else {
        date = room.createdAt;
      }

      return new Date(date);
    };

    // Sort the rooms (by date, descending):
    let rooms = this.props.rooms.sort((a, b) => {
      return getRoomDate(b) - getRoomDate(a);
    });

    // Use the sorted rooms when we render the component:
    rooms = rooms.map((room) => {
      return (
        <MenuMessage
          key={room.id}
          room={room}
        />
      );
    });

    return (
      <div className="menu">
        <div className="header">
          <h3>Messages</h3>
          <button
          	className="compose"
            // Make sure that you add ".bind(this)" so that we
            // can access the props from "createRoom":
          	onClick={this.createRoom.bind(this)}
    	    ></button>
        </div>
        <ul>
          {rooms}
        </ul>

      </div>
    )
  }
}

MenuContainer.defaultProps = {
  rooms: [],
};

// We map the state to a props that we can use
// Our mapStateToProps function will read the global
// Redux state (from the argument state) and return an
// object that simulates the behaviour of passing down props
const mapStateToProps = (state) => {
  return {
    rooms: state
  };
};

// We connect the our redux actions to a local prop using
// mapDispatchToProps object and passing it to the
// connect-function at the end of the file

//Now, when we use `this.props.actionName` in our component
//the `setRooms` function declared in our actions will be called.
const mapDispatchToProps = {
  setRooms,
  selectRoom,
  addRoom, // Add this line!
};

// We apply our map x to props by using the connect function
// It seems this is similar to passing a props on the parent class <MenuContainer passProps />
MenuContainer = connect(
  mapStateToProps,
  mapDispatchToProps
)(MenuContainer);

export default MenuContainer;
