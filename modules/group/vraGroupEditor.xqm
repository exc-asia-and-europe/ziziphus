xquery version "3.0";

import module namespace app="http://github.com/hra-team/rosids-shared/config/app" at "/apps/rosids-shared/modules/ziziphus/config/app.xqm";
import module namespace image-link-generator="http://hra.uni-heidelberg.de/ns/tamboti/modules/display/image-link-generator" at "/apps/tamboti/modules/display/image-link-generator.xqm";
import module namespace security="http://exist-db.org/mods/security" at "/apps/tamboti/modules/search/security.xqm";
import module namespace console="http://exist-db.org/xquery/console";

declare namespace vra="http://www.vraweb.org/vracore4.htm";
declare namespace functx = "http://www.functx.com";

declare option exist:serialize "method=html5 media-type=text/html omit-xml-declaration=yes indent=yes";


(:  FUNCTX :)
declare function functx:substring-before-last($arg as xs:string? , $delim as xs:string) as xs:string {
   if (matches($arg, functx:escape-for-regex($delim)))
   then (
       replace($arg, concat('^(.*)', functx:escape-for-regex($delim),'.*'), '$1')
   ) else (
       ''
   )
};

declare function functx:escape-for-regex($arg as xs:string?) as xs:string {
   replace($arg, '(\.|\[|\]|\\|\||\-|\^|\$|\?|\*|\+|\{|\}|\(|\))','\\$1')
};

declare variable $local:user := security:get-user-credential-from-session()[1];
declare variable $local:userpass := security:get-user-credential-from-session()[2];
declare variable $local:temp-db := "/db/data/temp/";

declare %private function local:extract-uuids-and-workdir($uuid as xs:string ) {
    let $files := doc($local:temp-db  || $uuid || ".xml")//option
    let $remove-id-document := xmldb:remove($local:temp-db, $uuid || ".xml")
    return
    <data>
        {
            for $file in $files
            let $collection := functx:substring-before-last($file/text(), '/')
            let $workrecord-id := data(doc($file/text())//vra:work/@id)
            return
                if(security:can-read-collection($collection))
                then (
                    <record>
                        <id>{$workrecord-id}</id>
                        <collection>{$collection}</collection>
                    </record>               
                ) else ( () )
        }
    </data>
};

declare %private function local:run($uuid as xs:string) {
      let $uuid-workdir := local:extract-uuids-and-workdir($uuid)
      return 
          if( count( $uuid-workdir/record) > 0 )
          then (
            let $first-tupel := $uuid-workdir/record[1]
            return
                <html>
                    <head>
                        <title>Ziziphus Image DB - Group editor</title>
                        <link rel="stylesheet" type="text/css" href="/exist/apps/ziziphus/resources/css/bootstrap.min.css"/>
                        <link rel="stylesheet" type="text/css" href="/exist/apps/ziziphus/resources/css/layout.css"/>
                        <link rel="stylesheet" type="text/css" href="/exist/apps/ziziphus/resources/css/record.css"/>
                        <link rel="stylesheet" type="text/css" href="/exist/apps/ziziphus/resources/script/mingos-uwindow/themes/ziziphus/style.css"/>
                        <link rel="stylesheet" type="text/css" href="/exist/apps/ziziphus/resources/script/layout-default-latest.css"/>
                        <link rel="stylesheet" type="text/css" href="/exist/apps/ziziphus/resources/css/jquery-ui.css"/>
                        <link rel="stylesheet" type="text/css" href="/exist/apps/rosids-shared/resources/css/autocomplete.css"/>
                        <link rel="stylesheet" type="text/css" href="/exist/apps/ziziphus/resources/css/group.css"/>
                    </head>
                    <body>
                        <div class="ui-layout-center outer-center">
                            <div class="full" style="height:100%">
                                <iframe id="iEditor" src="/exist/apps/ziziphus/record.html?id={$first-tupel/id}&amp;workdir={$first-tupel/collection}"></iframe>
                            </div>
                        </div>
                        <div class="ui-layout-south outer-south">
                            <div class="scroll-pane ui-widget ui-widget-header ui-corner-all">
                                <ul class="scroll-content">
                                    {local:thumBar($uuid-workdir)}
                                </ul>
                            </div>
                             <div class="scroll-bar-wrap ui-widget-content ui-corner-bottom" style="overflow:hidden;">
                                <div class="scroll-bar"></div>
                            </div>
                        </div>
                    
                        <script type="text/javascript" src="/exist/apps/ziziphus/resources/script/jquery-1.9.1.js"/>
                        <script type="text/javascript" src="/exist/apps/ziziphus/resources/script/jquery-ui-1.10.2.custom.min.js"/>
                        <script type="text/javascript" src="/exist/apps/ziziphus/resources/script/jquery.layout-latest.min.js"/>
                        <script type="text/javascript" src="/exist/apps/ziziphus/resources/script/group/group.js"/> 
                    </body>
                </html>
            ) else (
                local:error-page(<div>No readable records found<div>{$uuid}</div></div>)
            ) 
};

declare function local:thumBar($uuid-workdir) { 
    for $record in $uuid-workdir/record
    let $vraWorkRecord  := collection(xmldb:encode('/db/data'))//vra:vra/vra:work[@id = $record/id]
    let $imageRecordId  := if(exists($vraWorkRecord/vra:relationSet/vra:relation/@pref[.='true']))
                                then $vraWorkRecord/vra:relationSet/vra:relation[@pref='true'][1]/@relids
                                else $vraWorkRecord/vra:relationSet/vra:relation[1]/@relids
    return
        <li><img src="{image-link-generator:generate-href($imageRecordId, 'tamboti-thumbnail')}" alt="{$imageRecordId}" class="relatedImage" onclick="loadRecord('{$record/collection}')" title="{$imageRecordId}" /></li>
};

declare %private function local:groupeditor($uuid as xs:string) {
   
        if(doc-available($local:temp-db  || $uuid || ".xml"))
        then (
            system:as-user($local:user, $local:userpass, local:run($uuid))  
        ) else (
            local:error-page('could not read id file')
        )
};

declare %private function local:error-page($error-text) {
    <html>
        <head>
            <title>Ziziphus Image DB - Group editor</title>
        </head>
        <body>
            <div>user: {$local:user}</div>
            <div>An error occured:</div>
            <div>{$error-text}</div>
        </body>
    </html>
};

let $uuid := request:get-parameter('id', '2014-12-04-15-17-56-299')
return 
    if($uuid != '')
    then (
        local:groupeditor($uuid)
    ) else (
        local:error-page('id parameter missing')
    )
  
