document.getElementById("editBtn").click();
document.getElementById("heroSub").textContent = "把作品写进代码与光影";
document.getElementById("aboutP1").textContent = "这是保存流程测试的一段简介。";
document.querySelector('input[data-ct="wechat"]').value = "lzj_demo_2026";
document.getElementById("btnSave").click();
var saved = JSON.parse(localStorage.getItem("lzj_portfolio_data_v1"));
return { heroNow: document.getElementById("heroSub").textContent, savedHero: saved.heroSub, savedWechat: saved["ct:wechat"], savedAbout: saved.aboutP1, editModeOff: !document.body.classList.contains("edit-mode") };
