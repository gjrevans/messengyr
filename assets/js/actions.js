// A Redux action should simply return an object with the action's type,
// and some eventual data, which will be used by the reducer later.
export function setRooms(rooms) {
  return {
    type: "SET_ROOMS",
    rooms,
  }
};

export function selectRoom(roomId) {
  return {
    type: "SELECT_ROOM",
    roomId,
  }
};

export function addRoom(room) {
  return {
    type: "ADD_ROOM",
    room,
  }
};

export function addMessage(message, roomId) {
  return {
    type: "ADD_MESSAGE",
    message,
    roomId,
  }
};
