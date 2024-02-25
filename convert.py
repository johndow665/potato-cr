def extract_shellcode(file_path):
    # Чтение содержимого файла
    with open(file_path, 'r') as file:
        content = file.read()

    # Извлечение шеллкода из содержимого
    start = content.find('{') + 1
    end = content.find('}')
    shellcode = content[start:end].strip()

    # Удаление всех пробелов и переносов строк
    shellcode = shellcode.replace('\n', '').replace('\r', '').replace('\t', '').replace(' ', '')

    return shellcode

def convert_to_powershell_format(shellcode, output_file):
    # Форматирование шеллкода для PowerShell
    ps_shellcode = f'$shellcode = [byte[]] ({shellcode})'

    # Запись в файл
    with open(output_file, 'w') as file:
        file.write(ps_shellcode)

if __name__ == '__main__':
    input_file = 'shell.c'
    output_file = 'p_shell.txt'

    shellcode = extract_shellcode(input_file)
    convert_to_powershell_format(shellcode, output_file)

    print(f'Шеллкод был успешно преобразован и сохранен в {output_file}')