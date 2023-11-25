import socket
# ホスト名を取得、表示

def main():
  print('hello world')
  host = socket.gethostname()
  print(host)
  ip = socket.gethostbyname(host)
  print(ip) # 192.168.○○○.○○○
if __name__ == "__main__":
  main()