import { LinksType } from "@/lib/Constants"
import { create } from "zustand"

type SidebarStore = {
    selectedLink: LinksType,
    showMenu: boolean,
    setSelectedLink: (link: LinksType) => void
    setShowMenu: (menu: boolean) => void
}

export const useSidebarStore = create<SidebarStore>((set) => ({
    selectedLink: LinksType.Products,
    showMenu: false,
    setSelectedLink: (link) => set({ selectedLink: link }),
    setShowMenu: (menu) => set({ showMenu: !menu })
}))