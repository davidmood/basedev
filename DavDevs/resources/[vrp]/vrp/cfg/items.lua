local cfg = {}

cfg.items = {	
    ---------------------------------------------------------	
    --[ Ultilitários legais ]--------------------------------	
    ---------------------------------------------------------
    ["mochila"] = { "Mochila",0 },
    ["celular"] = { "Celular",3 },
    ["radio"] = { "Radio",1.0 },
	["celular"] = { "Celular",3 },
	["notebook"] = { "Notebook",5.1 },
	["maquininha"] = { "Maquininha",3 },
	["alianca"] = { "Aliança",0 },
	["roupas"] = { "Roupas",8.0 },
	["identidade"] = { "Identidade",0 },
	["aneldecompromisso"] = { "Anel de Compromisso",1.0 },
    ---------------------------------------------------------
	--[ Ultilitários Ilegais]--------------------------------
	---------------------------------------------------------
	["furadeira"] = { "Furadeira",5.0 },
	["colete"] = { "Colete",8.0 },
	["c4"] = { "C-4",5.0 },
	["serra"] = { "Serra",5.0 },
	["placa"] = { "Placa",1.0 },
	["algemas"] = { "Algemas",1 },
	["capuz"] = { "Capuz",0.5 },
	["lockpick"] = { "Lockpick",10 },
	["dinheirosujo"] = { "Dinheiro Sujo",0 },
	["parafall"] = { "Parafall",0.01 },
	---------------------------------------------------------
    --[ Itens da Medicina ]----------------------------------
    ---------------------------------------------------------
	--{ Itens Medicos}
	["morfina"] = { "Morfina",0.01 },
	["bandagem"] = { "Bandagem",0.7 },
	--{ Remédios}
    ["dorflex"] = { "Dorflex",0 },
    ["cicatricure"] = { "Cicatricure",0 },
    ["dipiroca"] = { "Dipiroca",0 },
    ["nocucedin"] = { "Nocucedin",0 },
    ["paracetanal"] = { "Paracetanal",0 },
    ["decupramim"] = { "Decupramim",0 },
    ["buscopau"] = { "Buscopau",0 },
    ["navagina"] = { "Navagina",0 },
    ["analdor"] = { "Analdor",0 },
    ["sefodex"] = { "Sefodex",0 },
    ["nokusin"] = { "Nokusin",0 },
	["glicoanal"] = { "Glicoanal",0 },
	["xerelto"] = { "Xerelto",0.1 },
    ---------------------------------------------------------
    --[ Mecanica ]-------------------------------------------
    ---------------------------------------------------------
	["nitro"] = { "Garrafa de Nitro",0.1 },
	["repairkit"] = { "Kit de Reparos",1 },
	["militec"] = { "Militec-1",0.8 },
	["ferramenta"] = { "Ferramenta",3 },
    ---------------------------------------------------------
    --[ Comidas ]--------------------------------------------
    ---------------------------------------------------------
	["xburguer"] = { "Xburguer",0.5 },
	["pizza"] = { "Pizza",0.01 },
	["laranja"] = { "Laranja",0.8 },
	["chocolate"] = { "Chocolate",1.0 },
	["pirulito"] = { "Pirulito",1.0 },
    ---------------------------------------------------------
    --[ Bebidas ]--------------------------------------------
	---------------------------------------------------------
	--{ Normais }
	["garrafadeagua"] = { "Garrafadeagua",0.5 },
	--{ Energeticas }
	["cafe"] = { "Cafe",0.01 },
	["energetico"] = { "Energético",0.3 },
	--{ Alcoólicas }
	["cerveja"] = { "Cerveja",0.7 },
	["tequila"] = { "Tequila",0.7 },
	["vodka"] = { "Vodka",0.7 },
	["whisky"] = { "Whisky",0.7 },
	["conhaque"] = { "Conhaque",0.7 },
	["absinto"] = { "Absinto",0.7 },
	---------------------------------------------------------
	--[ Drogas Legalizadas ]---------------------------------
	---------------------------------------------------------
    ["pedemaconhaLegalizada"] = { "Pé de maconha Legalizada",0.01 },
    ["maconhapodadaLegalizada"] = { "Maconha Podada Legalizada",0.1 },
	["baseadolegalizado"] = { "Baseado Legalizado",0.1 },
	---------------------------------------------------------
	--[ Itens de Invasão Hacker ]----------------------------
	---------------------------------------------------------
	["pendrive"] = { "Pendrive",0.1 },
	["logsinvasao"] = { "Logs de Invasão",0.1 },
	["keysinvasao"] = { "Keys para Invasão",1.0 },
	["pendriveinformacoes"] = { "Pendrive com Informações",0.1 },
	["acessodeepweb"] = { "Acesso á DeepWeb",1.0 },
	["keycard"] = { "Keycard",0.1 },
	---------------------------------------------------------
	--[ Itens Roubadas ]-------------------------------------
	---------------------------------------------------------
	["relogioroubado"] = { "Relógio Roubado",0.3 },
	["pulseiraroubada"] = { "Pulseira Roubada",0.2 },
	["anelroubado"] = { "Anel Roubado",0.2 },
	["colarroubado"] = { "Colar Roubado",0.2 },
	["brincoroubado"] = { "Brinco Roubado",0.2 },
	["carteiraroubada"] = { "Carteira Roubada",0.2 },
	["tabletroubado"] = { "Tablet Roubado",0.2 },
	["sapatosroubado"] = { "Sapatos Roubado",0.2 },
	---------------------------------------------------------
	--[ Organização Criminosa de Fabricação de Armas ]-------
	---------------------------------------------------------
	["capsula"] = { "Cápsula",0.03 },
	["polvora"] = { "Pólvora",0.03 },
	["armacaodearma"] = { "Armacao de Arma",0.8 },
	["pecadearma"] = { "Peça de arma",1.0 },
	["caixademunicao"] = { "Caixa de Munição",0.8 },
	---------------------------------------------------------
	--[ Organização Criminosa de Maconha ]-------------------
	---------------------------------------------------------
	["adubo"] = { "Adubo",0.8 },
	["fertilizante"] = { "Fertilizante",0.8 },
	["maconha"] = { "Maconha",0.8 },
	---------------------------------------------------------
	--[ Organização Criminosa de Coca ]----------------------
	---------------------------------------------------------
	["folhadecoca"] = { "Folha de Cocaina",0.8 },
	["pastadecoca"] = { "Pasta de Cocaina",0.8 },
	["cocaina"] = { "Cocaína",0.8 },
	---------------------------------------------------------
	--[ Organização Criminosa de Meta ]----------------------
	---------------------------------------------------------
	["acidobateria"] = { "Ácido de bateria",0.8 },
	["anfetamina"] = { "Anfetamina",0.8 },
	["metanfetamina"] = { "Metanfetamina",0.8 },
	---------------------------------------------------------
	--[ Organização Criminosa de LSD ]----------------------
	---------------------------------------------------------
	["fungo"] = { "Fungo",0.8 },
    ["dietilamina"] = { "Dietilamina",0.8 },
	["lsd"] = { "LSD",0.8 },
	---------------------------------------------------------
	--[ Itens de Pescaria ]----------------------------------
	---------------------------------------------------------
	["isca"] = { "Isca",0.6 },
	["dourado"] = { "Dourado",0.6 },
	["corvina"] = { "Corvina",0.6 },
	["salmao"] = { "Salmão",0.6 },
	["pacu"] = { "Pacu",0.6 },
	["pintado"] = { "Pintado",0.6 },
	["pirarucu"] = { "Pirarucu",0.6 },
	["tilapia"] = { "Tilápia",0.6 },
	["tucunare"] = { "Tucunaré",0.6 },
	["lambari"] = { "Lambari",0.6 },
	---------------------------------------------------------
	--[ Itens de Caça ]--------------------------------------
	---------------------------------------------------------
	["carnedecormorao"] = { "Carne de Cormorão",0.7 },
	["carnedecorvo"] = { "Carne de Corvo",0.7 },
	["carnedeaguia"] = { "Carne de Águia",0.8 },
	["carnedecervo"] = { "Carne de Cervo",0.9 },
	["carnedecoelho"] = { "Carne de Coelho",0.7 },
	["carnedecoyote"] = { "Carne de Coyote",1 },
	["carnedelobo"] = { "Carne de Lobo",1 },
	["carnedepuma"] = { "Carne de Puma",1.3 },
	["carnedejavali"] = { "Carne de Javali",1.4 },
	---------------------------------------------------------
	--[ Itens de Minerios ]----------------------------------
	---------------------------------------------------------
	["diamante"] = { "Min. Diamante",0.90 },
	["ouro"] = { "Min. Ouro",0.75 },
	["bronze"] = { "Min. Bronze",0.60 },
	["ferro"] = { "Ferro",0.07 },
	["rubi"] = { "Min. Rubi",0.75 },
	["esmeralda"] = { "Min. Esmeralda",0.90 },
	["safira"] = { "Min. Safira",0.25 },
	["topazio"] = { "Min. Topazio",0.90 },
	["ametista"] = { "Min. Ametista",0.60 },
	["diamante2"] = { "Diamante",0.30 },
	["ouro2"] = { "Ouro",0.25 },
	["bronze2"] = { "Bronze",0.20 },
	["ferro2"] = { "Ferro",0.30 },
	["rubi2"] = { "Rubi",0.25 },
	["esmeralda2"] = { "Esmeralda",0.30 },
	["safira2"] = { "Safira",0.25 },
	["topazio2"] = { "Topazio",0.30 },
	["ametista2"] = { "Ametista",0.20 },
	["carbono"] = { "carbono",0.07 },
	--["aco"] = { "aco",0.001 },
	["goldbar"] = { "Barra de OURO",0.5 },
	---------------------------------------------------------
	--[ Trabalhos ]------------------------------------------
	---------------------------------------------------------
	["graos"] = { "Graos",0.5 },
	["graosimpuros"] = { "Graos Impuros",0.5 },
	-- -- --
	["orgao"] = { "Órgão",1.2 },
	-- -- --
	["linha"] = { "Linha de Costura",0.01 },
	["tecido"] = { "Tecido Para Costurar",0.5 },
	-- -- --
	["garrafavazia"] = { "Garrafa Vazia",0.2 },
	["garrafadeleite"] = { "Garrafa de Leite",0.5 },
	-- -- --
	["tora"] = { "Tora de Madeira",0.6 },
	-- -- --
	["sacodelixo"] = { "Saco de Lixo",1 },
	-- -- --
	["encomenda"] = { "Encomenda",1.2 },
	---------------------------------------------------------
	--[ MISC ]-----------------------------------------------
	---------------------------------------------------------
	["buque"] = { "Buquê de Flores",1.0 },
	["colardeperolas"] = { "Colar de Pérolas",1.0 },
	["pulseiradeouro"] = { "Pulseira de Ouro",1.0 },
	["coumadin"] = { "Coumadin",0.1 },
	["etiqueta"] = { "Etiqueta",0 },
	["fichas"] = { "Fichas",0.01 },
	["querosene"] = { "Querosene",0.5 },
	["urso"] = { "Urso",0.01 },
	["ingresso"] = { "Ingresso",0.1 },

}

local function load_item_pack(name)
	local items = module("cfg/item/"..name)
	if items then
		for k,v in pairs(items) do
			cfg.items[k] = v
		end
	end
end

load_item_pack("armamentos")

return cfg