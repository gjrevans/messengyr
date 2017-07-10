// Our reduces talk to state to let it know if it should
// update and what to change
const room = (state, action) => {
  switch (action.type) {
    case "SELECT_ROOM":
      let isActive = (state.id === action.roomId);

      return Object.assign({}, state, {
        isActive,
      });

    default:
      return state;
  }
};

const rooms = (state = [], action) => {
  switch (action.type) {
    case "SET_ROOMS":
      return action.rooms;

    case "SELECT_ROOM":
      // Loop through the rooms:
      return state.map(r => {
        // Determine the state of each room:
        return room(r, action);
      });

    case "ADD_ROOM":
      return [
        action.room,
        ...state,
      ];

    default:
      return state;
  }
};

export default rooms;
