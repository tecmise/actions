import os
import base64
import hashlib


def process_files(list_path):
    """
    Processa uma lista de caminhos, concatena o conteúdo dos arquivos em base64
    e retorna o hash MD5 do resultado.

    Args:
        list_path (list): Lista de caminhos para arquivos ou diretórios

    Returns:
        str: Hash MD5 do conteúdo concatenado em base64
    """
    all_files = []

    # Função auxiliar para coletar todos os arquivos recursivamente
    def collect_files(path):
        if os.path.isfile(path):
            all_files.append(path)
        elif os.path.isdir(path):
            for item in os.listdir(path):
                collect_files(os.path.join(path, item))

    # Coleta todos os arquivos dos caminhos fornecidos
    for path in list_path:
        collect_files(path)

    # Concatena o conteúdo de todos os arquivos em base64
    concatenated_content = b""
    for file_path in all_files:
        try:
            with open(file_path, 'rb') as f:
                file_content = f.read()
                encoded_content = base64.b64encode(file_content)
                concatenated_content += encoded_content
        except Exception:
            # Ignora arquivos que não podem ser lidos
            continue

    # Calcula o MD5 do conteúdo concatenado
    md5_hash = hashlib.md5(concatenated_content).hexdigest()

    return md5_hash


# Exemplo de uso:
if __name__ == "__main__":
    # Esta parte seria substituída pela chamada real da função
    # paths = ["/caminho/para/diretorio", "/caminho/para/arquivo.txt"]
    # result = process_files(paths)
    # print(result)

    # Para teste via linha de comando
    import sys

    if len(sys.argv) > 1:
        result = process_files(sys.argv[1:])
        print(result)