<CTYPE html>
<html lang="en">
 
<head>
    <title>Harvard Forum</title>
 
 
    <link href="http://getbootstrap.com/dist/css/bootstrap.min.css" rel="stylesheet">
 
    <link href="http://getbootstrap.com/examples/jumbotron-narrow/jumbotron-narrow.css" rel="stylesheet">

    <!--<link href="../static/index.css" rel="stylesheet">-->
 
</head>
 
<body>
 
 <div class="container">
      <div class="header">
          <a href="/"><img src="../static/logo.png" alt="Askii" style="width:100px;height:50px;"></a>
      </div>
 
      <div class="jumbotron">
        <h1>Questions</h1>
        <!--<form class="table" action="/getQuestions" method="GET">-->

        <?php 
        
        $titles = json_decode(exec('python ../app.py'), true);
        #$titles = json_decode($_GET['titles']);
        $nr_elm = count($titles);

        $html_table = '<table border="1" cellspacing="0" cellpadding="2"><tr>';
        $nr_col = 1;  

        if ($nr_elm > 0) 
        {
            for($i=0; $i<$nr_elm; $i++) 
            {
                $html_table .= '<td>' .$titles[$i]. '</td>';
                $col_to_add = ($i+1) % $nr_col;
                if($col_to_add == 0) 
                { 
                  $html_table .= '</tr><tr>'; 
                }
            }
            if($col_to_add != 0) 
                $html_table .= '<td colspan="'. ($nr_col - $col_to_add). '">&nbsp;</td>';
        }
        $html_table = str_replace('<tr></tr>', '', $html_table);
        echo $html_table; 
        ?>

        <!--<?php if (count($titles) > 0)?>

          <table>
            <thead>
                <th>Question</th>
                <!--<th>Number of Responses</th>-->
        <!--    </thead>

            <tbody>
              <?php foreach ($titles as $row): array_map('htmlentities', $row); ?>
              <tr>
                <td><?php echo implode('</td><td>', $row); ?></td>
              </tr>
              <?php endforeach; ?>
            </tbody>
            </table>
        <?php endif; ?>-->

        <!--</form>-->
      </div>
</body>
 
</html>

