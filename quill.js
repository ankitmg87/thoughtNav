// ThoughtNav. Focus Groups. Made Easy.
// © Aperio Insights 30th April 2021. Version 1.0.0
// All Rights Reserved


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


function saveEmailAndPassword(email, password){
localStorage.setItem("email", email);
localStorage.setItem("password", password);
}

function getEmail(){
var email = localStorage.getItem("email");
return email;
}

function getPassword(){
var password = localStorage.getItem("password");
return password;
}