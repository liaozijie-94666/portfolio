document.getElementById("editBtn").click();
var bannerHidden = document.getElementById("editBanner").hidden;
var toolHidden = document.getElementById("editTool").hidden;
var editBtnHidden = document.getElementById("editBtn").hidden;
var bodyEdit = document.body.classList.contains("edit-mode");
var ce = document.getElementById("heroSub").getAttribute("contenteditable");
var inputs = document.querySelectorAll(".edit-mode .contact-input").length;
return { bannerHidden: bannerHidden, toolHidden: toolHidden, editBtnHidden: editBtnHidden, bodyEdit: bodyEdit, contenteditable: ce, visibleInputs: inputs };
