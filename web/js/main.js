var isDark = true;

$(window).on("load", function () {
    var themeMode = getValueLocal("themeMode")
    if (themeMode != null) {
        isDark = themeMode == "true"
    }
    setThemeMode(isDark)

    $("#themeMode").click(function () {
        isDark = !isDark
        setThemeMode(isDark)
    })

    $('#copyToClipboard').click(function () {
        copyToClipboard('classOutputHidden');
        showSnackbar("Copied")
    });
});

function readFile(a, b) {
    $.get(a, function (data) {
        b(data)
    });
}

function setThemeMode(isDarkMode) {
    console.log('[setThemeMode] '+isDarkMode)
    setValueLocal("themeMode", isDarkMode);
    if (isDarkMode) {
        $("#themeMode").text("🌙")
        $(".myBg1").removeClass("bg-light").addClass("bg-dark")
        $(".myBg2").removeClass("bg-info").addClass("bg-secondary")
        $(".myText1").removeClass("text-dark").addClass("text-light")
    } else {
        $("#themeMode").text("🌤")
        $(".myBg1").removeClass("bg-dark").addClass("bg-light")
        $(".myBg2").removeClass("bg-secondary").addClass("bg-info")
        $(".myText1").removeClass("text-light").addClass("text-dark")
    }
}

function copyToClipboard(element) {
    /* Get the text field */
    var copyText = document.getElementById(element);

    /* Select the text field */
    copyText.select();
    copyText.setSelectionRange(0, 99999); /* For mobile devices */

    /* Copy the text inside the text field */
    navigator.clipboard.writeText(copyText.value);
}

function showSnackbar(text) {
    var x = document.getElementById("snackbar");
    x.innerHTML = text
    x.className = "show";
    setTimeout(function () {
        x.className = x.className.replace("show", "");
    }, 3000);
}

function getValueLocal(key) {
    if (typeof (Storage) !== "undefined") {
        return localStorage.getItem(key);
    } else {
        console.log("Local store not support");
    }
}

function setValueLocal(key, value) {
    if (typeof (Storage) !== "undefined") {
        localStorage.setItem(key, value);
    } else {
        console.log("Local store not support");
    }
}