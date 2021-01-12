function alertMessage(text) {
    alert(text)
}

function readLocalStorage(){
  var text = localStorage.getItem("content");

  return text;
}


function setInitialValue(text) {
  localStorage.setItem("content", text);
}
