function inlineedit(obj)
{
    var objId = $(obj).attr('id');

	//alert(objId);

    var $parent_tr = $(obj).parent().parent();
        $tds = $parent_tr.find("td");             // Finds all children <td> elements
    var $lasttd=  $parent_tr.find('th').html('<img height="15px" width="15px" src="/assets/save.jpg" class="prevent" onclick="updateRecord(this)" id="'+objId+'">');     //Last TD with Image
    var $tdValue; 
    var $tdInput;


//	$parent_tr.find('img').attr('src', "/assets/save.jpg");

      $.each($tds, function() {               // Visits every single <td> element
	$tdValue = $(this).text();		// Prints out the text within the <td>
	$tdInput = '<input type="text" value="'+$tdValue+'">';

	$(this).html($tdInput);
      });
 		
}

