import csv

info_produtos = []
print("FIGHT LIKE A GIRL SYSTEM")
print("1 - Cadastro de Produtos")
print("2 - Sair do Programa")

op = None
tries = 0
while op not in [1, 2]:
  try:
    op = int(input("Informe a sua opção: "))
  except ValueError:
    tries = tries + 1
    print("Digita 1 para cadastrar produto ou 2 para sair. Se errar demais eu formato seu computador")
    if tries >= 3:
      print("Paciência acabou, tchau!")
      exit(0)

while op != 2:
  if op == 1:
    produto = []

    cod_produto = None
    while cod_produto == None:
      try:
        cod_produto = int(input("Qual o código do produto?\n"))
      except ValueError:
        print("Para de brincar e manda o código do produto de verdade agora!")

    descricao_produto = input("Qual a descrição do produto?\n")
    while len(descricao_produto) == 0:
      tipo_embalagem = input("Qual a descrição do produto, sem zueira?\n")

    valor_produto = None
    while valor_produto == None:
      try:
        valor_produto = float(input("Valor do produto?\n"))
      except ValueError:
        print(
          "Qual o preço do produto, faz favor. Se tiver centavos, coloca ponto no lugar da vírgula, assim, ó: 9.99 ao invés de 9,99")

    tipo_embalagem = input("Tipo de embalagem?\n")
    while len(tipo_embalagem) == 0:
      tipo_embalagem = input("Tipo da embalagem (sério agora)?\n")
    info_produtos.append([cod_produto, descricao_produto, valor_produto, tipo_embalagem])

  tries = 0
  op = None
  while op not in [1, 2]:
    try:
      op = int(input("Digita 1 para novo produto ou 2 para sair\n"))
    except ValueError:
      op = None
      tries = tries +1
      print("Se continuar errando de propósito eu formato seu computador")
      if tries >= 3:
        print("Paciência acabou, tchau!")
        exit(0)

with open('1_5_arquivo_produto.csv', 'a', newline='') as file_handler:
  writer = csv.writer(file_handler, delimiter=',')
  for line in info_produtos:
    writer.writerow(line)
print("Obrigada por usar nosso programa! Com (muita) sorte, seus dados estão no 1_5_arquivo_produto.csv")
