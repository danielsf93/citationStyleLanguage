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


<div class="marc">  
      
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
        

{* Organizando a Informação *}

    {assign var="dataFormatada" value=$smarty.now|date_format:"%Y%m%d%H%M%S.0"}
    {assign var="zeroZeroCinco" value="$dataFormatada"}

    {assign var="zeroZeroOito" value="      s2023    bl            000 0 por d"}

    {assign var="zeroDoisZero" value="  a{if $isbn|trim}{$isbn}{else}{/if}7 "}
        
    {assign var="zeroDoisQuatro" value="a{$publication->getStoredPubId('doi')|escape}2DOI"}

    {assign var="zeroQuatroZero" value="  aUSP/ABCD0 "}

    {assign var="zeroQuatroUm" value="apor  "}

    {assign var="zeroQuatroQuatro" value="abl1 "}


     {* Obter Primeiro Autor *}
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


    {assign var="doisQuatroCinco" value="10a{$publication->getLocalizedFullTitle()|escape}h[recurso eletrônico]  "}






{assign var="doisMeiaZero" value="a {$local}b{$holder}c{$publication->getData('copyrightYear')}0 "}

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

{* Demais autores *}
{assign var="additionalAuthors" value=[]}
{foreach $authors as $index => $author}
    {if $index != 0}
        {assign var="additionalAuthors" value=array_merge($additionalAuthors, [$author])}
    {/if}
{/foreach}


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
		
    {/if}
{/foreach}
   
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

{assign var="ldr" value="01131nam 22000241a 4500 "} 

{* Calculando o comprimento da variável $rec005 *}
{assign var="rec005POS" value=0}
{assign var="rec005CAR" value=sprintf('%04d', strlen($zeroZeroCinco) + 0)}
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

{assign var="rec260POS" value=$rec245CAR + $rec245POS}
{assign var="rec260CAR" value=sprintf('%04d', strlen($doisMeiaZero) + 0)}
{assign var="rec260" value="260"|cat:$rec260CAR|cat:sprintf('%05d', $rec260POS)}

{assign var="rec490POS" value=$rec260CAR + $rec260POS}
{assign var="rec490CAR" value=sprintf('%04d', strlen($quatroNoveZero) + 3)}
{assign var="rec490" value="490"|cat:$rec490CAR|cat:sprintf('%05d', $rec490POS)}

{assign var="rec500POS" value=$rec490CAR + $rec490POS}
{assign var="rec500CAR" value=sprintf('%04d', strlen($cincoZeroZero) + 3)}
{assign var="rec500" value="500"|cat:$rec500CAR|cat:sprintf('%05d', $rec500POS - 3)}


{assign var="numAutoresAdicionais" value=count($additionalAuthors)}
{assign var="rec700All" value=''} 

{foreach $additionalAuthors as $additionalAuthor}
    {assign var="rec700" value=''} 
    
    {assign var="rec700POS" value=sprintf('%05d', $rec500CAR + $rec500POS)}
    
    {assign var="seteZeroZero" value="1 a{$additionalAuthor->getLocalizedFamilyName()|escape}, {$additionalAuthor->getLocalizedGivenName()|escape}"}

    {if $additionalAuthor->getOrcid()}
        {assign var="seteZeroZero" value="$seteZeroZero0{$additionalAuthor->getOrcid()}"} 
    {else}
        {assign var="seteZeroZero" value="$seteZeroZero0 "} 
    {/if}

    {assign var="seteZeroZero" value="$seteZeroZero4org"}

    {assign var="rec700CAR" value=sprintf('%04d', strlen($seteZeroZero))}

    {assign var="rec700" value=$rec700|cat:"700"|cat:$rec700CAR|cat:$rec700POS - 3|cat:$seteZeroZero|cat:"  "}
    
    {assign var="rec500POS" value=$rec700POS}
    {assign var="rec500CAR" value=$rec700CAR}
    
    {assign var="rec700All" value=$rec700All|cat:$rec700} 
{/foreach}

{assign var="rec700All" value=str_replace(" ", "", $rec700All)}


{assign var="rec856APOS" value=$rec500CAR + $rec500POS}
{assign var="rec856ACAR" value=sprintf('%04d', strlen($oitoCincoMeiaA) - 1)}

{if $numAutoresAdicionais > 0}
    {assign var="rec856APOS" value=$rec700CAR + $rec700POS}
    {assign var="rec856ACAR" value=sprintf('%04d', strlen($oitoCincoMeiaA) - 1)}
{/if}

{assign var="rec856A" value="856"|cat:$rec856ACAR|cat:sprintf('%05d', $rec856APOS - 3)}

{assign var="rec856BPOS" value=$rec856ACAR + $rec856APOS}
{assign var="rec856BCAR" value=sprintf('%04d', strlen($oitoCincoMeiaB) - 2)}
{assign var="rec856B" value="856"|cat:$rec856BCAR|cat:sprintf('%05d', $rec856BPOS - 3)}

{assign var="rec945POS" value=$rec856BCAR + $rec856BPOS}
{assign var="rec945CAR" value=sprintf('%04d', strlen($noveQuatroCinco) + 1)}
{assign var="rec945" value="945"|cat:$rec945CAR|cat:sprintf('%05d', $rec945POS - 3)}






 
    <button id="downloadButton" class="botao">Baixar Arquivo MARC</button>
	

<style>
 
    #downloadButton {
		font-weight: bold;
        padding: 5px 18px; /* Espaçamento interno */
        background-color: #ececec; /* Cor de fundo */
        color: #076fb1; /* Cor do texto */
        border: 100; /* Remover borda */
        border-radius: 5px; /* Bordas arredondadas */
        cursor: pointer; /* Cursor ao passar por cima */
    
    }

   
</style>

{assign var="numAutoresAdicionais" value=$additionalAuthors|count}
{assign var="totalautores" value=22000205+($numAutoresAdicionais*12)}
{assign var="totalcaracteres" value=sprintf('%05d', strlen($zeroZeroCinco) + strlen($zeroZeroOito) + strlen($zeroDoisZero) + strlen($zeroDoisQuatro) + strlen($zeroQuatroZero) + strlen($zeroQuatroUm) + strlen($zeroQuatroQuatro) + strlen($umZeroZero) + strlen($doisQuatroCinco) + strlen($doisMeiaZero) + strlen($quatroNoveZero) + strlen($cincoZeroZero) + strlen($additionalAuthorsExport) + strlen($oitoCincoMeiaA) + strlen($oitoCincoMeiaB) + strlen($noveQuatroCinco) + 169)}

<script>
    document.addEventListener('DOMContentLoaded', function() {
        var downloadButton = document.getElementById('downloadButton');
        downloadButton.addEventListener('click', function() {
            var text = "{$totalcaracteres}nam {$totalautores}a 4500 {$rec005|escape:'javascript'}{$rec008|escape:'javascript'}{$rec020|escape:'javascript'}{$rec024|escape:'javascript'}{$rec040|escape:'javascript'}{$rec041|escape:'javascript'}{$rec044|escape:'javascript'}{$rec100|escape:'javascript'}{$rec245|escape:'javascript'}{$rec260|escape:'javascript'}{$rec490|escape:'javascript'}{$rec500|escape:'javascript'}{$rec700All|escape:'javascript'}{$rec856A|escape:'javascript'}{$rec856B|escape:'javascript'}{$rec945|escape:'javascript'}{$zeroZeroCinco|escape:'javascript'}{$zeroZeroOito|escape:'javascript'}{$zeroDoisZero|escape:'javascript'}{$zeroDoisQuatro|escape:'javascript'}{$zeroQuatroZero|escape:'javascript'}{$zeroQuatroUm|escape:'javascript'}{$zeroQuatroQuatro|escape:'javascript'}{$umZeroZero|escape:'javascript'}{$doisQuatroCinco|escape:'javascript'}{$doisMeiaZero|escape:'javascript'}{$quatroNoveZero|escape:'javascript'}{$cincoZeroZero|escape:'javascript'}{$additionalAuthorsExport|escape:'javascript'}{$oitoCincoMeiaA|escape:'javascript'}{$oitoCincoMeiaB|escape:'javascript'}{$noveQuatroCinco|escape:'javascript'}";
            var fileName = 'omp.mrc'; // Nome do arquivo a ser baixado

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