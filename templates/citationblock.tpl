{* How to cite *}
{if $citation}
	<div class="item citation">
		<section class="sub_item citation_display">
			<h2 class="label">
				{translate key="submission.howToCite"}
			</h2>
			<div class="value">
				<div id="citationOutput" role="region" aria-live="polite">
					{$citation}
				</div>
				<div class="citation_formats">
					<button class="citation_formats_button label" aria-controls="cslCitationFormats" aria-expanded="false" data-csl-dropdown="true">
						{translate key="submission.howToCite.citationFormats"}
					</button>
					<div id="cslCitationFormats" class="citation_formats_list" aria-hidden="true">
						<ul class="citation_formats_styles">
							{foreach from=$citationStyles item="citationStyle"}
								<li>
									<a
											aria-controls="citationOutput"
											href="{url page="citationstylelanguage" op="get" path=$citationStyle.id params=$citationArgs}"
											data-load-citation
											data-json-href="{url page="citationstylelanguage" op="get" path=$citationStyle.id params=$citationArgsJson}"
									>
										{$citationStyle.title|escape}
									</a>
								</li>
							{/foreach}
						</ul>
						{if count($citationDownloads)}
							<div class="label">
								{translate key="submission.howToCite.downloadCitation"}
							</div>
							<ul class="citation_formats_styles">
								{foreach from=$citationDownloads item="citationDownload"}
									<li>
										<a href="{url page="citationstylelanguage" op="download" path=$citationDownload.id params=$citationArgs}">
											<span class="fa fa-download"></span>
											{$citationDownload.title|escape}
										</a>
									</li>
								{/foreach}
							</ul>
						{/if}
					</div>
				</div>
			</div>
		</section>
	</div>

<div class="sub_item marc">MARC

<hr>


Teste:<br>





<hr>


{assign var="dataFormatada" value=$smarty.now|date_format:"%Y%m%d%H%M%S.0"}
{assign var="zeroZeroCinco" value="$dataFormatada"}

{assign var="zeroZeroOito" value="      s2023    bl            000 0 por d"}

{* Pegar o ISBN *}
        {assign var="isbn" value=""}
        {foreach $publication->getData('publicationFormats') as $publicationFormat}
            {assign var="identificationCodes" value=$publicationFormat->getIdentificationCodes()}
            {while $identificationCode = $identificationCodes->next()}
                {if $identificationCode->getCode() == '02' || $identificationCode->getCode() == '15'}
                    {assign var="isbn" value=$identificationCode->getValue()|replace:"-":""|replace:".":""}
                    {break} {* Encerra o loop ao encontrar o ISBN *}
                {/if}
            {/while}
        {/foreach}
{assign var="zeroDoisZero" value="  a{if $isbn|trim}{$isbn}{else}{/if}7 "}

{assign var="zeroDoisQuatro" value="a{$publication->getStoredPubId('doi')|escape}2DOI"}

{assign var="zeroQuatroZero" value="  aUSP/ABCD0 "}

{assign var="zeroQuatroUm" value="apor  "}

{assign var="zeroQuatroQuatro" value="abl1 "}

{*umZeroZero*}
{foreach from=$publication->getData('authors') item=author name=authorLoop}
    {if $smarty.foreach.authorLoop.index == 0}
        {assign var="surname" value=$author->getLocalizedFamilyName()|escape}
        {assign var="givenName" value=$author->getLocalizedGivenName()|escape}
        {assign var="orcid" value=$author->getOrcid()|default:''}
        {assign var="affiliation" value=$author->getLocalizedAffiliation()|default:''}
        {assign var="locale" value=$author->getCountryLocalized()|escape}

        {if $affiliation|strstr:'Universidade de São Paulo'}
            {if $orcid}
                {assign var="umZeroZero" value="a{$surname}, {$givenName}0{$orcid}4org5(*)"}
            {else}
                {assign var="umZeroZero" value="a{$surname}, {$givenName}0 4org5(*)"}
            {/if}
        {else}
            {if $orcid && $affiliation}
                {assign var="umZeroZero" value="a{$surname}, {$givenName}0{$orcid}5(*)7INT8{$affiliation}9{$locale}"}
            {elseif $orcid}
                {assign var="umZeroZero" value="a{$surname}, {$givenName}0{$orcid}5(*)7INT9{$locale}"}
            {elseif $affiliation}
                {assign var="umZeroZero" value="a{$surname}, {$givenName}7INT8{$affiliation}9{$locale}"}
            {else}
                {assign var="umZeroZero" value="a{$surname}, {$givenName}5(*)9{$locale}"}
            {/if}
        {/if}
    {/if}
{/foreach}

{assign var="doisQuatroCinco" value="10a{$publication->getLocalizedFullTitle(null, 'html')|strip_unsafe_html}h[recurso eletrônico]  "}

{assign var="doisMeiaZero" value="a LOCALb{$publication->getLocalizedData('copyrightHolder')}c{$publication->getData('copyrightYear')}0 "}

{assign var="quatroNoveZero" value=""}
{if $series}
    {assign var="seriesTitle" value=$series->getLocalizedFullTitle()}
    {if $seriesTitle}
        {assign var="quatroNoveZero" value="a {$seriesTitle}"}
    {/if}
{else}
    {assign var="quatroNoveZero" value="a "}
{/if}

{if $publication->getData('seriesPosition')}
    {assign var="quatroNoveZero" value=$quatroNoveZero|cat:"v {$publication->getData('seriesPosition')}"}
{else}
    {assign var="quatroNoveZero" value=$quatroNoveZero|cat:"v "}
{/if}

{assign var="quatroNoveZero" value=$quatroNoveZero|cat:"  "}

{assign var="cincoZeroZero" value="aDisponível em: http://{$smarty.server.HTTP_HOST}{$smarty.server.REQUEST_URI}. Acesso em: {$smarty.now|date_format:"%d.%m.%Y"}"}

{assign var="oitoCincoMeiaA" value="4 zClicar sobre o botão para acesso ao texto completouhttps://doi.org/{$publication->getStoredPubId('doi')|escape}3DOI"}

{$publicationFiles=$bookFiles}
{foreach from=$publicationFormats item=format}
    {pluck_files assign=pubFormatFiles files=$publicationFiles by="publicationFormat" value=$format->getId()}
    {foreach from=$pubFormatFiles item=file}
        {assign var=publicationFormatId value=$publicationFormat->getBestId()}

        {* Generate the download URL *}
        {if $publication->getId() === $monograph->getCurrentPublication()->getId()}
            {capture assign=downloadUrl}{url op="view" path=$monograph->getBestId()|to_array:$publicationFormatId:$file->getBestId()}{/capture}
        {else}
            {capture assign=downloadUrl}{url op="view" path=$monograph->getBestId()|to_array:"version":$publication->getId():$publicationFormatId:$file->getBestId()}{/capture}
        {/if}
    {/foreach}
{/foreach}

{assign var="oitoCincoMeiaB" value="41zClicar sobre o botão para acesso ao texto completou{$downloadUrl}3Portal de Livros Abertos da USP  "}

{assign var="noveQuatroCinco" value="aPbMONOGRAFIA/LIVROc06j2023lNACIONAL"}

<hr>
{*Organizar numeros*}
{* Calculando o comprimento da variável $rec005 *}
{assign var="rec005POS" value=0}
{assign var="rec005CAR" value=sprintf('%04d', strlen($zeroZeroCinco) + $rec005POS)}
{assign var="rec005" value="005"|cat:$rec005CAR|cat:sprintf('%05d', $rec005POS)}

{* Calculando o comprimento da variável $rec008 *}
{assign var="rec008POS" value=$rec005CAR + $rec005POS}
{assign var="rec008CAR" value=sprintf('%04d', strlen($zeroZeroOito) + 0)}
{assign var="rec008" value="008"|cat:$rec008CAR|cat:sprintf('%05d', $rec008POS)}

{* Calculando o comprimento da variável $rec020 *}
{assign var="rec020POS" value=$rec008CAR + $rec008POS}
{assign var="rec020CAR" value=sprintf('%04d', strlen($zeroDoisZero) - 3)}
{assign var="rec020" value="020"|cat:$rec020CAR|cat:sprintf('%05d', $rec020POS)}

{* Calculando o comprimento da variável $rec024 *}
{assign var="rec024POS" value=$rec020CAR + $rec020POS}
{assign var="rec024CAR" value=sprintf('%04d', strlen($zeroDoisQuatro) + 3)}
{assign var="rec024" value="024"|cat:$rec024CAR|cat:sprintf('%05d', $rec024POS)}

{* Calculando o comprimento da variável $rec040 *}
{assign var="rec040POS" value=$rec024CAR + $rec024POS}
{assign var="rec040CAR" value=sprintf('%04d', strlen($zeroQuatroZero) - 3)}
{assign var="rec040" value="040"|cat:$rec040CAR|cat:sprintf('%05d', $rec040POS)}

{* Calculando o comprimento da variável $rec041 *}
{assign var="rec041POS" value=$rec040CAR + $rec040POS}
{assign var="rec041CAR" value=sprintf('%04d', strlen($zeroQuatroUm) + 0)}
{assign var="rec041" value="041"|cat:$rec041CAR|cat:sprintf('%05d', $rec041POS)}

{* Calculando o comprimento da variável $rec044 *}
{assign var="rec044POS" value=$rec041CAR + $rec041POS}
{assign var="rec044CAR" value=sprintf('%04d', strlen($zeroQuatroQuatro) + 0)}
{assign var="rec044" value="044"|cat:$rec044CAR|cat:sprintf('%05d', $rec044POS)}

{* Calculando o comprimento da variável $rec100 *}
{assign var="rec100POS" value=$rec044CAR + $rec044POS}
{assign var="rec100CAR" value=sprintf('%04d', strlen($umZeroZero) + 3)}
{assign var="rec100" value="100"|cat:$rec100CAR|cat:sprintf('%05d', $rec100POS)}

{* Calculando o comprimento da variável $rec245 *}
{assign var="rec245POS" value=$rec100CAR + $rec100POS}
{assign var="rec245CAR" value=sprintf('%04d', strlen($doisQuatroCinco) - 3)}
{assign var="rec245" value="245"|cat:$rec245CAR|cat:sprintf('%05d', $rec245POS)}

{*Mostrar numerais*}



{$rec005}<br>
{$rec008}<br>
{$rec020}<br>
{$rec024}<br>
{$rec040}<br>
{$rec041}<br>
{$rec044}<br>
{$rec100}<br>
{$rec245}<br>

<hr>
{*Mostrar texto*}

<b>LDR= </b><br>
<b>005= </b>{$zeroZeroCinco}<br>
<b>008= </b>{$zeroZeroOito}<br>
<b>020= </b>{$zeroDoisZero}<br>
<b>024= </b>{$zeroDoisQuatro}<br>
<b>040= </b>{$zeroQuatroZero}<br>
<b>041= </b>{$zeroQuatroUm}<br>
<b>044= </b>{$zeroQuatroQuatro}<br>
<b>100= </b>{$umZeroZero}<br>
<b>245= </b>{$doisQuatroCinco}<br>
<b>260= </b>{$doisMeiaZero}<br>
<b>490= </b>{$quatroNoveZero}<br>
<b>500= </b>{$cincoZeroZero}<br>
{assign var="additionalAuthorsExport" value=""}
{foreach from=$publication->getData('authors') item=author name=authorLoop}
    {if $smarty.foreach.authorLoop.index > 0}
        {assign var="surname" value=$author->getLocalizedFamilyName()|escape}
        {assign var="givenName" value=$author->getLocalizedGivenName()|escape}
        {assign var="orcid" value=$author->getOrcid()|default:''}

        {if $orcid}
            {assign var="seteZeroZero" value="1 a{$surname}, {$givenName}0{$orcid}4org"}
        {else}
            {assign var="seteZeroZero" value="1 a{$surname}, {$givenName}0 4org"}
        {/if}

        {assign var="additionalAuthorsExport" value="$additionalAuthorsExport{$seteZeroZero}"}
		<b>700= </b>{$seteZeroZero}<br>
    {/if}
{/foreach}
<b>856a= </b>{$oitoCincoMeiaA}<br>
<b>856b= </b>{$oitoCincoMeiaB}<br>
<b>945= </b>{$noveQuatroCinco}<br>





<hr>
 <button id="downloadButton" class="botao">Baixar Arquivo MARC</button>

<script>
    document.addEventListener('DOMContentLoaded', function() {
        var downloadButton = document.getElementById('downloadButton');
        downloadButton.addEventListener('click', function() {
var text = "{$totalcaracteres}nam {$totalautores}a 4500 {$rec005|escape:'javascript'}{$rec008|escape:'javascript'}{$rec020|escape:'javascript'}{$rec024|escape:'javascript'}{$rec040|escape:'javascript'}{$rec041|escape:'javascript'}{$rec044|escape:'javascript'}{$rec100|escape:'javascript'}{$rec245|escape:'javascript'}{$zeroZeroCinco|escape:'javascript'}{$zeroZeroOito|escape:'javascript'}{$zeroDoisZero|escape:'javascript'}{$zeroDoisQuatro|escape:'javascript'}{$zeroQuatroZero|escape:'javascript'}{$zeroQuatroUm|escape:'javascript'}{$zeroQuatroQuatro|escape:'javascript'}{$umZeroZero|escape:'javascript'}{$doisQuatroCinco|escape:'javascript'}{$doisMeiaZero|escape:'javascript'}{$quatroNoveZero|escape:'javascript'}{$cincoZeroZero|escape:'javascript'}{$additionalAuthorsExport|escape:'javascript'}{$oitoCincoMeiaA|escape:'javascript'}{$oitoCincoMeiaB|escape:'javascript'}{$noveQuatroCinco|escape:'javascript'}";
var fileName = 'ompBlock.mrc'; // Nome do arquivo a ser baixado

            var blob = new Blob([text], { type: 'text/plain' });
            if (window.navigator.msSaveOrOpenBlob) {
                window.navigator.msSaveBlob(blob, fileName);
            } else {
                var elem = window.document.createElement('a');
                elem.href = window.URL.createObjectURL(blob);
                elem.download = fileName;
                document.body.appendChild(elem);
                elem.click();
                document.body.removeChild(elem);
            }
        });
    });
</script>

</div>




{/if}