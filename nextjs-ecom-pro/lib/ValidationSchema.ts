import { z } from "zod";

// product validation
export const ProductFormValidation = z.object({
    name: z.string().min(2, { message: "Product name is required" }),
    price: z.coerce.number().min(1, { message: "Product base price is required" }),
    tax_class: z.string().min(2, { message: "Product tax class is required" }),
    sku_number: z.string().min(2, { message: "SKU is required" }),
    barcode_number: z.string().min(2, { message: "Product barcode is required" }),
    on_shelf: z.coerce.string().refine((value) => Number(value) > 0, { message: "Shelf quantity must be greater than zero" }),
})

export type ProductFormError = {
    [Key in keyof z.infer<typeof ProductFormValidation>]?: string[]
}