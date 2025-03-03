import React from 'react'

export default function LoginForm() {
    return (
        <form className="w-full md:max-w-[450px] mx-auto px-5 xl:px-0 flex flex-col items-center">
            <h1 className='text-xl font-semibold mb-8 text-primary'>Login</h1>
            <div className="md:space-y-5 space-y-3 w-full">
                <input type="email" className={`border w-full px-2 py-3 rounded-md placeholder:text-[13.5px] focus:outline-none focus:ring-0 text-sm border-inherit`} placeholder='Email' />
                {/* {errors?.barcode_number && <p className='text-xs text-red-500 mt-2'>{errors.barcode_number}</p>} */}
                <input type="text" className={`border w-full px-2 py-3 rounded-md placeholder:text-[13.5px] focus:outline-none focus:ring-0 text-sm border-inherit`} placeholder='Password' />
                {/* {errors?.barcode_number && <p className='text-xs text-red-500 mt-2'>{errors.barcode_number}</p>} */}
            </div>
            <a href='#' className='mt-3 self-end text-end text-primary-light-dark font-semibold text-sm transition-all duration-200 hover:text-primary'>Forget password ?</a>
            <a href='/products' className='block my-8 w-full bg-primary-light rounded-md px-3 py-3 text-center focus:outline-none focus:ring-0 text-[15px] tracking-wide text-white font-medium transition-colors duration-200 hover:bg-primary'>Login</a>
            <h5 className='text-gray-500 text-[15px] font-medium'>Not a memeber yet? <a href="/users/sign-up" className='text-primary-light-dark transition-all duration-200 hover:text-primary'>Sign up</a></h5>
        </form>
    )
}
