def "nu-complete flatpak apps" [] {
    try {
        # 执行 flatpak list 命令获取应用列表
        let apps = (^flatpak list --app --columns=name,application | complete)
        
        if $apps.exit_code == 0 {
            $apps.stdout
            | lines
            | split column --regex '\s+(?!.*\s)' --number 2 name id
            | each { |row| 
                { 
                    value: $row.id, 
                    description: $row.name
                }
            }
        } else {
            []
        }
    } catch {
        # 出错时返回空列表
        []
    }
}
export extern "flatpak run" [
    app: string@"nu-complete flatpak apps"  # 应用程序包标识符
    ...args: string                         # 传递给应用程序的其他参数
]
