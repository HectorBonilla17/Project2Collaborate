
document.getElementById('get_file').onclick = function() {
    document.getElementById('my_file').click();
};

/* Header Dropdown */

function dropdownFunc() {
    document.getElementById("myDropdown").classList.toggle("show");
  }
  
  // Close the dropdown menu if the user clicks outside of it
  window.onclick = function(event) {
    if (!event.target.matches('.dropbtn')) {
      var dropdowns = document.getElementsByClassName("dropdown-content");
      var i;
      for (i = 0; i < dropdowns.length; i++) {
        var openDropdown = dropdowns[i];
        if (openDropdown.classList.contains('show')) {
          openDropdown.classList.remove('show');
        }
      }
    }
  }

  /* user settings submit */
  document.getElementById("studentSettings").submit();
  document.getElementById("facultySettings").submit();

/* grades table */

