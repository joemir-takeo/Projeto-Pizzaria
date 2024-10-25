use PDH
--1a Apenas criação de View sem uso de variavel 
create view vw_QtdeCliente as
select
TbCLiente.NomeCliente, sum(TbPedido.Qtde)as Total from TbCLiente
inner join TbPedido on TbCLiente.IdCliente = TbPedido.IdCliente
--where TbCLiente.IdCliente = 3
group by TbCLiente.NomeCliente

select * from vw_QtdeCliente

--1b Consulta com variavel sem View
DECLARE @idCliente int
SET @idCliente = 3
--create view vw_QtdeCliente as
select
TbCLiente.NomeCliente, sum(TbPedido.Qtde)as Total from TbCLiente
inner join TbPedido on TbCLiente.IdCliente = TbPedido.IdCliente
where TbCLiente.IdCliente = @idCliente
group by TbCLiente.NomeCliente

--1c Uso de variáveis dentro de uma View não funciona, pois as view se utilizam da base principal em filtro
--Acima, o mesmo exercicio desmembrado em duas partes. View e Variável
create view vw_QtdeCliente as
DECLARE @idCliente int
SET @idCliente = 3
select
TbCLiente.NomeCliente, sum(TbPedido.Qtde)as Total from TbCLiente
inner join TbPedido on TbCLiente.IdCliente = TbPedido.IdCliente
where TbCLiente.IdCliente = @idCliente
group by TbCLiente.NomeCliente

--02 Criação de View para facilitar consultas constantes
create view vw_ConsultaVenda as
select TbCliente.IdCliente, Qtde*Valor AS Total, TbCliente.NomeCliente,TbPedido.IdPedido, tbPedido.Qtde, tbProduto.NomeProduto, tbProduto.Valor from TbCLiente
inner join TbPedido on TbCLiente.IdCliente = TbPedido.IdCliente
inner join TbProduto on TbPedido.IdProduto = TbProduto.IdProduto
select * from vw_ConsultaVenda

--03
SELECT * FROM vw_ConsultaVenda
--3a Uso de estrutura condicional CASE/ELSE
SELECT IdCliente AS ID, NomeCliente, Qtde * Valor AS 'Valor Total',
CASE WHEN Qtde * Valor >200 THEN 'Premium'
	 WHEN Qtde * Valor>100 THEN 'Tradicional'
	 ELSE 'Popular'
	 END AS CategoriaVenda 
FROM vw_ConsultaVenda

--3b Uso de variável para calculo de desconto somente para o valor informado
DECLARE @desconto Float
SET @desconto = 0.9
SELECT NomeProduto, Valor,
--SELECT NomeProduto, Valor,
	CASE WHEN Valor = 80 THEN TbProduto.Valor * @desconto
		ELSE 0
	END AS 'Desconto'
FROM TbProduto
