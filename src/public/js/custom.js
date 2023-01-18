var initialized = false;
$(document).ready(function() {
  $('#ajaxButton').on('click', function () {
      var x = $("#geneTextarea").val();
      console.log(x);
      $('#phenos').DataTable().ajax.reload();
  });

$(".dataTables_info").hide();

 $('#phenos').DataTable({
   processing: true,
    info: false,
    paging: false,
    lengthChange: false,
    serverSide: true,
    deferLoading: 57,
    searching: false,
    ajax: {
      url: "/api",
      type: "GET",
      data: function ( d ) {
        d.genes = function () {
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
