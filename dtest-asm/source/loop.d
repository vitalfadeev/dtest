struct Loop
{
    enum ulong N = 1;
    ulong n = N;


    void Loop()
    {
        version ( Beta_Generic )
        {
            // Example 12.1a. Typical for-loop in C++
            for ( ulong i = 0; i < n; i++ ) 
            {
                // (loop body)
            }    
        }
        version ( Beta1 )
        {
            asm
            {
                // Example 12.1b. For-loop, not optimized
                mov     RBX, this;
                mov     RCX, n[ RBX ];  // Load n
                xor     RAX, RAX;       // i = 0
            LoopTop:
                cmp     RAX, RCX;       // i < n
                jge     LoopEnd;        // Exit when i >= n

                // (loop body)          // Loop body goes here

                add     RAX, 1;         // i++      // It may be unwise to use the inc instruction for adding 1 to the loop counter. The inc
                                                    // instruction has a problem with writing to only part of the flags register, which makes it less
                                                    // efficient than the add instruction on some older Intel processors and may cause false
                                                    // dependences on other processors.
                jmp     LoopTop;        // Jump back
            LoopEnd:
                ;
            }
        }
        version ( Beta2 )
        {
            // The most important problem with the loop in example 12.1b is that there are two jump
            // instructions. We can eliminate one jump from the loop by putting the branch instruction in
            // the end:
            asm
            {
                // Example 12.1c. For-loop with branch in the end
                mov    RBX, this     ;
                mov    RCX, n[ RBX ] ; // Load n
                test   RCX, RCX      ; // Test n
                jng    LoopEnd       ; // Skip if n <= 0
                xor    RAX, RAX      ; // i = 0
            LoopTop:
                
                // (loop body)         // Loop body goes here
                
                add     RAX, 1       ; // i++
                cmp     RAX, RCX     ; // i < n
                jl      LoopTop      ; // Loop back if i < n
            LoopEnd:        
                ;
            }
        }
        version ( Beta3 )
        {
            // The cmp instruction in example 12.1c and 12.2b can be eliminated if the counter ends at
            // zero because we can rely on the add instruction for setting the zero flag. This can be done
            // by counting down from n to zero rather counting up from zero to n:

            asm 
            {
                // Example 12.3. Loop with counting down
                mov     RBX, this     ;
                mov     RCX, n[ RBX ] ; // Load n
                test    RCX, RCX      ; // Test n
                jng     LoopEnd       ; // Skip if n <= 0
            LoopTop:

                // (loop body)          // Loop body goes here

                sub     RCX, 1        ; // n--
                jnz     LoopTop       ; // Loop back if not zero
            LoopEnd:
                ;
            }

            // Now the loop overhead is reduced to just two instructions, which is the best possible. The
            // jecxz and loop instructions should be avoided because they are less efficient.
        }
    }
}


struct LoopForEach
{
    enum ulong N = 1;
    ulong n = N;
    int[ N ] array;

    void LoopForEach()
    {
        version ( Beta1 )
        {
            asm 
            {
                // Example 12.4a. For-loop with array
                // section .text
                // default rel
                mov     RBX, this            ;
                mov     RCX, n[ RBX ]        ; // Load n
                test    RCX, RCX             ; // Test n
                jng     LoopEnd              ; // Skip if n <= 0
                xor     EAX, EAX             ; // i = 0
                lea     RSI, array[ RBX ]    ; // Address of an array
            LoopTop:

                // Loop body: Add 1 to all elements in Array:
                add     dword ptr [ RSI + 4 * RAX ], 1;

                add     EAX, 1               ; // i++
                cmp     EAX, ECX             ; // i < n
                jl      LoopTop              ; // Loop back if i < n
            LoopEnd:
                ;
            }

            // The address of the start of the array is in rsi and the index in rax. The index is multiplied
            // by 4 in the address calculation because the size of each array element is 4 bytes.
        }
        version ( Beta2 )
        {
            // It is possible to modify example 12.4a to make it count down rather than up, but the data
            // cache is optimized for accessing data forwards, not backwards. Therefore it is better to
            // count up through negative values from -n to zero. This is possible by making a pointer to
            // the end of the array and using a negative offset from the end of the array:

            asm 
            {
                // Example 12.4b. For-loop with negative index from end of array
                // section .text
                // default rel
                mov     RBX, this               ;
                mov     RCX, n[ RBX ]           ; // Load n
                lea     RSI, array[ RBX ]       ; // Address of array
                lea     RSI, [ RSI + 4 * RCX ]  ; // Point to end of array
                neg     RCX                     ; // i = -n
                jnl     LoopEnd                 ; // Skip if (-n) >= 0
            LoopTop:
                // Loop body: Add 1 to all elements in Array:
                add     dword ptr[ RSI + 4 * RCX ], 1;

                add     RCX, 1                  ; // i++
                js      LoopTop                 ; // Loop back if i < 0
            LoopEnd:
                ;
            }
        }
        version ( Beta3 )
        {
            // A slightly different solution is to multiply n by 4 and count from -4*n to zero:

            asm 
            {
                // Example 12.4c. For-loop with neg. index multiplied by element size
                //section .text
                //default rel
                mov     RBX, this           ;
                mov     RCX, n[ RBX ]       ; // Load n
                shl     RCX, 2              ; // n * 4
                jng     LoopEnd             ; // Skip if (4*n) <= 0
                lea     RSI, array[ RBX ]   ; // Address of array
                add     RSI, RCX            ; // Point to end of array
                neg     RCX                 ; // i = -4*n
            LoopTop:
                
                // Loop body: Add 1 to all elements in Array:
                add     dword ptr [ RSI + RCX ], 1  ;

                add     RCX, 4              ; // i += 4
                js      LoopTop             ; // Loop back if i < 0
            LoopEnd:            
                ;
            }

            // There is no significant difference in speed between example 12.4b and 12.4c, but the latter
            // method is useful if the size of the array elements is not 1, 2, 4 or 8 so that we cannot use
            // the scaled index addressing
        }
    }
}

unittest
{
    LoopForEach loopForEach;
    loopForEach.LoopForEach();

    assert( loopForEach.array[ 0 ] == 1 );
}

