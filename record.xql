xquery version "3.0";

declare namespace exist = "http://exist.sourceforge.net/NS/exist";
declare namespace vra = "http://www.vraweb.org/vracore4.htm";

import module namespace request="http://exist-db.org/xquery/request";
import module namespace transform = "http://exist-db.org/xquery/transform";

declare option exist:serialize "method=xhtml media-type=application/xhtml+xml";

declare function local:createVraRecords($uuid as xs:string?) {
     let $vraWorkRecord  := collection('/db/apps/ziziphusData/priyapaul/files/work')/vra:vra/vra:work[@id = $uuid]
     let $imageRecordId  := if(exists($vraWorkRecord/vra:relationSet/vra:relation/@pref[.='true']))
                                then $vraWorkRecord/vra:relationSet/vra:relation[@pref='true']/@relids
                                else $vraWorkRecord/vra:relationSet/vra:relation[1]/@relids
     let $vraImageRecord := collection('/db/apps/ziziphusData/priyapaul/files/images')/vra:vra/vra:image[@id = $imageRecordId]
     let $vraImageId    := $vraImageRecord/@refid
     let $id := substring($uuid,3)
     let $imageTitle := $vraWorkRecord//vra:titleSet/vra:title/text()
     return

         <table>
                <tr>
                    {local:transformVraRecord($vraWorkRecord, $uuid, 'work')}
                    <td class="imagePanel">





<!--                        <div class="currentImage" style="width:200px;height:200px;background:#dddddd;">



                            <a href="records/{concat($vraImageId,'-big.jpg')}" target="_blank">             -->
                                <img id="vraImage" src="https://kjc-fs1.kjc.uni-heidelberg.de/ImageService/api/get/priya_paul/{$id}.jpg" alt="{$imageTitle}" />
                            <!-- </a>

                        </div>        -->
                    </td>
                    {local:transformVraRecord($vraImageRecord, $imageRecordId, 'image')}                    
                </tr>
         </table>        
};

declare function local:transformVraRecord($root as node(), $id as xs:string, $vraRecordType as xs:string) {

        let $parameters := <parameters>
                                <param  name="type" value="{$vraRecordType}"/>
                                <param  name="recordId" value="{$id}"/>
                            </parameters>
        return
            transform:transform($root, doc("/db/apps/ziziphus/resources/xsl/vra-record.xsl"), $parameters)
};



let $contextPath := request:get-context-path()

(: ######## hardcoded dataset for testing!!! ######### :)
let $uuid := request:get-parameter("id", "w_0a0b6027-1b3d-56ce-a3b1-14e2baac93dc")

return
<html xmlns="http://www.w3.org/1999/xhtml"
      xmlns:vra="http://www.vraweb.org/vracore4.htm" 
      xmlns:exist="http://exist.sourceforge.net/NS/exist"
      xmlns:ev="http://www.w3.org/2001/xml-events"
      xmlns:xf="http://www.w3.org/2002/xforms"
      xmlns:bf="http://betterform.sourceforge.net/xforms"
      xmlns:bfc="http://betterform.sourceforge.net/xforms/controls"
      bf:transform="/apps/ziziphus/resources/xsl/ziziphus.xsl">
    <head>
        <title>Ziziphus Image DB</title>
        <link rel="stylesheet" type="text/css" href="resources/css/bootstrap.min.css"/>
        <link rel="stylesheet" type="text/css" href="resources/css/layout.css"/>
        <link rel="stylesheet" type="text/css" href="resources/css/record.css"/>
    </head>
    <body id="ziziphusImageDB">
        <div id="overlay" style="position:absolute;z-index:9999;width:100%;height:100%;background:#444444;">
            <span style="font-weight:bold; font-size:200% !important;position:absolute;top:50%;width:100%;text-align:center;">... loading Ziziphus Image Database</span>
        </div>
        <div style="display:none">
            <xf:model id="m-main">
                <xf:instance id="i-control-center">
                    <data xmlns="">
                        <currentform/>
                        <uuid>{$uuid}</uuid>
                    </data>
                </xf:instance>
            </xf:model>
            <xf:group id="controlCenter" model="m-main">
                <xf:action ev:event="unload-subform"   model="m-main" if="string-length(instance('i-control-center')/currentform) &gt; 0">
                    <xf:toggle>
                        <xf:case value="concat('c-',instance('i-control-center')/currentform,'-view')" />
                    </xf:toggle>
                    <xf:load show="none" targetid="{{concat(instance('i-control-center')/currentform,'_MountPoint')}}"/>
                </xf:action>
                <xf:action ev:event="clear-currentform" model="m-main">
                    <xf:setvalue ref="instance('i-control-center')/currentform" value="''"/>
                </xf:action>
            </xf:group>
        </div>


        <div dojoType="dijit.MenuBar" id="mainMenu">

            <div dojoType="dijit.PopupMenuBarItem" label="View">
                <div dojoType="dijit.Menu" id="View">
                    <div data-dojo-type="dijit.CheckedMenuItem" data-dojo-props="onClick:function(){{toggleView(this,'imagerecord')}},checked:true">Image Record</div>
                    <div data-dojo-type="dijit.CheckedMenuItem" data-dojo-props="onClick:function(){{toggleView(this,'workrecord')}},checked:true">Work Record</div>
                    <div data-dojo-type="dijit.CheckedMenuItem" data-dojo-props="onClick:function(){{toggleView(this,'imagepane')}},checked:true">Image Area</div>
                    <div data-dojo-type="dijit.CheckedMenuItem" data-dojo-props="onClick:function(){{toggleView(this,'twoColumnMode')}},checked:false">2 column mode</div>
                </div>
            </div>
            <div dojoType="dijit.PopupMenuBarItem" label="Collapse">
                <div dojoType="dijit.Menu" id="Collapse">
                    <div id="collapseAll" data-dojo-type="dijit.CheckedMenuItem" data-dojo-props="onClick:function(){{collapse(this,'all')}},checked:false">All</div>
                    <div id="collapseWork" data-dojo-type="dijit.CheckedMenuItem" data-dojo-props="onClick:function(){{collapse(this,'work')}},checked:false">Work Record</div>
                    <div id="collapseImage" data-dojo-type="dijit.CheckedMenuItem" data-dojo-props="onClick:function(){{collapse(this,'image')}},checked:false">Image Record</div>
                </div>
            </div>
        </div>
        {local:createVraRecords($uuid)}



        <script type="text/javascript" defer="defer">
           require(["dojo/parser",
                    "dijit/Menu",
                    "dijit/MenuBar",
                    "dijit/MenuBarItem",
                    "dijit/PopupMenuBarItem",
                    "dijit/DropDownMenu",
                    "dijit/MenuItem",
                    "dijit/CheckedMenuItem",
                    "dijit/TitlePane"]);
        </script>

        <script type="text/javascript" defer="defer" src="resources/script/ziziphus.js"/>
        <script type="text/javascript" defer="defer" src="resources/script/jquery-1.8.0.min.js"/>
        <script type="text/javascript">
                        dojo.addOnLoad(function(){{
                        dojo.addOnLoad(function(){{
                            var animation = dojo.fadeOut({{node: "overlay",duration: 1000}});
                            dojo.connect(animation, "onEnd", function(){{
                                dojo.style("overlay", "display","none");
                            }});
                            animation.play();
                        }});
                    }});

                    function toggleDetail(n, m){{
                        console.debug("this: ", n, " " , m);
                        $(n).toggleClass("icon-zoom-out");
                        $(n).toggleClass("icon-zoom-in");
                        $("#"+m).toggleClass("simple");
                        $("#"+m).toggleClass("full");

                    }}
        </script>
</body>
</html>
