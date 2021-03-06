<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="Util.*"%>
<%@ page import="RMI.RMI,java.util.ArrayList,java.lang.*;"%>

<jsp:include page="/WEB-INF/header.jsp" />

<%
	RMI rmi = (RMI) session.getAttribute("rmi");
	User utilizador = (User) request.getAttribute("utilizador");
	ArrayList<Topico> topicos = rmi.mostraTopicos(false);
	ArrayList<Grupo> grupos = rmi.getUserGroups(utilizador.getId());
	
	String erro = (String) request.getParameter("erro");
%>

<div class="container">
	<div class="row">

		<jsp:include page="/WEB-INF/sidebar.jsp" />

		<div class="col-md-9">
			<div class="conteudo">

				<div class="titulo">
					<h1>Nova ideia</h1>
				</div>

				<% if(erro != null && erro.equals("campos")){ %>
					<div class="alert alert-danger">Preencha todos os campos</div>
				<% } %>
				
				<div class="panel panel-default">
					<div class="panel-heading">
						<h3 class="panel-title">Formulário</h3>
					</div>
					<div class="panel-body">
						<form action="CriarIdeiaServlet" method="POST" class="form-horizontal" enctype="multipart/form-data" role="form">
							<div class="form-group">
								<label for="titulo" class="col-sm-2 control-label">Título</label>
								<div class="col-sm-10">
									<input type="text" class="form-control" name="titulo" placeholder="título da ideia">
								</div>
							</div>
							<div class="form-group">
								<label for="texto" class="col-sm-2 control-label">Texto</label>
								<div class="col-sm-10">
									<textarea name="texto" class="form-control" id="texto" rows="5"></textarea>
								</div>
							</div>



							<div class="form-group">

								<div class="col-sm-3 col-sm-offset-2">
									<input type="text" autocomplete="off" class="form-control" name="topicos" placeholder="pesquise um tópico">
								</div>
								<div class="col-sm-7">
									<span id="sugestoes"></span>
								</div>
							</div>
							<div class="form-group">
								<label for="topicos" class="col-sm-2 control-label">Tópicos</label>
								<div class="col-sm-10">

									<input type="text" autocomplete="off" class="form-control" name="topicosEscolhidos" placeholder="#tecnologia #ciencia">


								</div>

							</div>

							<div class="form-group">
								<label for="investir" class="col-sm-2 control-label">Investir</label>
								<div class="col-sm-2">
									<input type="text" class="form-control" name="investir" placeholder="10 Coinz">
								</div>
								<div class="col-sm-4">
									<strong>Preço por share:</strong> <span id="preco_share"></span>
								</div>

							</div>
							<div class="form-group">
								<label for="file" class="col-sm-2 control-label">Anexar ficheiro</label>
								<div class="col-sm-6">
									<input type="file" class="form-control" name="file">
								</div>

							</div>

							<div class="form-group">
								<label for="file" class="col-sm-2 control-label">Grupo</label>
								<div class="col-sm-4">
									<select name="grupo" class="form-control">
										<option value="0">Sem grupo (ideia pública)</option>
										<% for(Grupo g : grupos){ %>
											<option value="<%=g.getId() %>"><%=g.getNome() %></option>
										<% } %>
									</select>
								</div>

							</div>

							<div class="col-xs-12 col-sm-12 col-md-12">

								<button type="submit" class="btn btn-lg btn-info btn-block">Submeter ideia</button>
							</div>
						</form>

					</div>
				</div>



			</div>
		</div>
	</div>
</div>


<jsp:include page="/WEB-INF/footer.jsp" />

<script>
$(function() {
	var topicoInput = $( "[name=topicos]" );
	
	var sugestoes = $( "#sugestoes" );
	/*
	var tagsCount = {<%for(Topico t : topicos){
		out.print("'"+t.getTag()+"' : "+t.getNumIdeias()+", ");

	}%>};
	*/
	var tagsCount = {<%for(Topico t : topicos){
		  int numIdeias = rmi.numIdeiasTopico(t.getId());
		  out.print("'"+t.getTag()+"' : "+numIdeias+", ");

	}%>};
	
	var tags = [
	<%for(Topico t : topicos){
		out.print("'"+t.getTag()+"', ");

	}%>];
	
    topicoInput.keyup(function(){
    	sugestoes.html("");
    	var i = 0;
    	var res = "";
    	for(i; i < tags.length; i++){
    		var search = topicoInput.val().replace("#","");
    		if(search.length > 0 && tags[i].indexOf(search) >= 0){
    			res += "<a class='hashtag' onclick='adicionarTagInput(this.innerHTML)' href='#"+tags[i]+"'>#" + tags[i] + "</a> ("+tagsCount[tags[i]]+"), ";
    		}
    	}
    	sugestoes.html(res.substring(0,res.length - 2));
    });
    
    
    $("[name=investir]").keyup(function(){
    	var val = $("[name=investir]").val();
    	var conta = (val / 100000).toFixed(4);
    	if(conta != "NaN")
    		$("#preco_share").text(conta+" CoinZ");
    	else
    		$("#preco_share").text("--- CoinZ");
    });
    
    
    
    
  });
function adicionarTagInput(a){
	//console.log(a.href);
	var topicosEscolhidos = $( "[name=topicosEscolhidos]" );
	topicosEscolhidos.val(topicosEscolhidos.val() + a + " ");
	//topicosEscolhidos.append(a + ", ");
}
</script>
