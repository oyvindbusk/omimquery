var initialized = false;
$(document).ready(function() {
  $('#ajaxButton').on('click', function () {
      var x = $("#geneTextarea").val();
      console.log(x);
      $('#phenos').DataTable().ajax.reload();
  });


 $('#phenos').DataTable({
   processing: true,
    serverSide: true,
    paging: false,
    deferLoading: 57,
    searching: false,
    ajax: {
      url: "/api",
      type: "GET",
      data: function ( d ) {
        d.genes = function () {
          //return "fjdkfsjdskj";
          var gene = $('#geneTextarea').val();
          return gene;
        };
    }},
    select: true,
    columns: [
      { data: 'genename' },
      { data: 'symbols' },
      { data: 'mim' },
      { data: 'name' },
      { data: 'inheritance' }
  ]

  });
});
